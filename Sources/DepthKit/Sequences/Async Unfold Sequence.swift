// DepthKit © 2017–2025 Constantino Tsarouhas

/// Returns a sequence formed of a given element and lazy repeated applications of a given function on it.
public func asyncSequence<Element : Sendable, Failure>(
	first:	Element,
	next:	@escaping (Element) async throws(Failure) -> Element?
) -> some AsyncSequence<Element, Failure> {
	asyncSequence(state: first as Element?) { nextElement throws(Failure) in
		guard let current = nextElement else { return nil }
		nextElement = try await next(current)
		return current
	}
}

/// Returns a sequence formed from lazy repeated applications of a given function on a mutable state.
public func asyncSequence<Element : Sendable, State : Sendable, Failure>(
	state:	State,
	next:	@escaping (inout State) async throws(Failure) -> Element?
) -> some AsyncSequence<Element, Failure> {
	AsyncUnfoldSequence(state: state, unfold: next)
}

private struct AsyncUnfoldSequence<Element : Sendable, State : Sendable, Failure : Error> : AsyncSequence {
	
	/// The initial state.
	let state: State
	
	/// A function that produces the next element for a given state, or `nil` if the sequence has ended.
	let unfold: UnfoldFunction
	typealias UnfoldFunction = (inout State) async throws(Failure) -> Element?
	
	// See protocol.
	func makeAsyncIterator() -> AsyncIterator {
		.init(state: state, unfold: unfold)
	}
	
	struct AsyncIterator : AsyncIteratorProtocol {
		
		/// The state, or `nil` if the sequence has ended.
		var state: State?
		
		/// A function that produces the next element for a given state, or `nil` if the sequence has ended.
		let unfold: UnfoldFunction
		
		// See protocol.
		mutating func next(isolation actor: isolated (any Actor)?) async throws(Failure) -> Element? {
			guard var state else { return nil }
			if let result = try await unfold(&state) {
				self.state = state
				return result
			} else {
				self.state = state
				return nil
			}
		}
		
	}
	
}
