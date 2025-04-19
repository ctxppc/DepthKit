// DepthKit © 2017–2025 Constantino Tsarouhas

import AsyncAlgorithms

extension AsyncSequence {
	
	/// The first element, or `nil` if `self` is empty.
	public var first: Element? {
		get async throws(Failure) {
			for try await element in self {
				return element
			}
			return nil
		}
	}
	
	/// Returns the last element, or `nil` if `self` is empty.
	///
	/// - Complexity: O(*n*)
	public func last() async throws(Failure) -> Element? {
		var last: Element?
		for try await element in self {
			last = element
		}
		return last
	}
	
}

extension AsyncSequence where Self : Sendable, Element : Sendable {
	
	/// Returns a Boolean value indicating whether `self` and a given sequence contain the same elements in the same order.
	public func elementsEqual<Other : Sendable & AsyncSequence>(
		_ other: Other
	) async throws -> Bool where Other.Element == Element, Element : Equatable {
		try await elementsEqual(other, by: ==)
	}
	
	/// Returns a Boolean value indicating whether `self` and a given sequence contain the same elements in the same order.
	public func elementsEqual<Other : Sendable & AsyncSequence>(
		_ other:	Other,
		by equal:	(Element, Element) async throws -> Bool
	) async throws -> Bool where Other.Element == Element {
		let a = chain(self.map { $0 as Element? }, [nil].async)
		let b = chain(other.map { $0 as Element? }, [nil].async)
		for try await (a, b) in zip(a, b) {
			switch (a, b) {
				
				case (let a?, let b?):
				guard try await equal(a, b) else { return false }
				
				case (nil, nil):
				return true
				
				case (_?, nil), (nil, _?):
				return false
				
			}
		}
		preconditionFailure("Expected sentinel")
	}
	
	/// Returns a Boolean value indicating whether the initial elements of `self` are the same as the elements in a given sequence.
	public func starts<Prefix : Sendable & AsyncSequence>(
		with prefix:	Prefix
	) async throws -> Bool where Prefix.Element == Element, Element : Equatable {
		try await starts(with: prefix, by: ==)
	}
	
	/// Returns a Boolean value indicating whether the initial elements of `self` are the same as the elements in a given sequence.
	public func starts<Prefix : Sendable & AsyncSequence>(
		with prefix:	Prefix,
		by equal:		(Element, Element) async throws -> Bool
	) async throws -> Bool where Prefix.Element == Element {
		let seq = chain(self.map { $0 as Element? }, [nil].async)
		let prefix = chain(prefix.map { $0 as Element? }, [nil].async)
		for try await (seqElement, prefixElement) in zip(seq, prefix) {
			switch (seqElement, prefixElement) {
				
				case (let a?, let b?):
				guard try await equal(a, b) else { return false }
				
				case (nil, nil), (_?, nil):
				return true
				
				case (nil, _?):
				return false
				
			}
		}
		preconditionFailure("Expected sentinel")
	}
	
}
