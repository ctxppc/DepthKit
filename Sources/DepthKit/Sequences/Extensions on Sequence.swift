// DepthKit © 2017–2025 Constantino Tsarouhas

extension Sequence {
	
	/// Returns the first element in `self` which satisfies a given predicate.
	public func first<Failure>(where predicate: (Element) async throws(Failure) -> Bool) async throws(Failure) -> Element? {
		for element in self {
			if try await predicate(element) {
				return element
			}
		}
		return nil
	}
	
	/// Returns the elements in `self` that satisfy a given predicate.
	public func filter<Failure>(_ predicate: (Element) async throws(Failure) -> Bool) async throws(Failure) -> [Element] {
		var result: [Element] = []
		for element in self {
			if try await predicate(element) {
				result.append(element)
			}
		}
		return result
	}
	
	/// Returns the elements of `self` transformed using a given function.
	public func map<T, Failure>(_ transform: (Element) async throws(Failure) -> T) async throws(Failure) -> [T] {
		var result: [T] = []
		for element in self {
			result.append(try await transform(element))
		}
		return result
	}
	
}

extension Sequence where Element : Comparable {
	
	/// Returns a Boolean value indicating whether the sequence precedes another sequence in a lexicographical ordering, ordering a shorter sequence after the longer one when the short sequence is a prefix of the longer sequence.
	///
	/// - Parameter other: A sequence to compare to this sequence.
	/// - Parameter orderingShorterSequencesAfter: The unit value.
	
	/// - Returns: `true` if `self` precedes `self` in a lexicographical ordering and `self` is longer than `other`; otherwise, `false`.
	internal func lexicographicallyPrecedes<OtherSequence : Sequence>(_ other: OtherSequence, orderingShorterSequencesAfter: ()) -> Bool where OtherSequence.Element == Element {
		
		var elementsOfFirstSequence = self.makeIterator()
		var elementsOfSecondSequence = other.makeIterator()
		
		while let elementOfFirstSequence = elementsOfFirstSequence.next() {
			
			guard let elementOfSecondSequence = elementsOfSecondSequence.next() else { return true }
			
			if elementOfFirstSequence < elementOfSecondSequence {
				return true
			} else if elementOfFirstSequence > elementOfSecondSequence {
				return false
			}
			
		}
		
		return false
		
	}
	
}
