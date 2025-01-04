// DepthKit © 2017–2025 Constantino Tsarouhas

/// A sequence without elements.
///
/// An empty sequence can be of any element or failure type but never returns an element and never throws an error. The simplest empty sequence is typed `ElementSequence<Never, Never>`.
public struct EmptyAsyncSequence<Element, Failure> : AsyncSequence {
	
	/// Creates an empty sequence.
	public init() {}
	
	// See protocol.
	public struct AsyncIterator : AsyncIteratorProtocol {
		
		// See protocol.
		public func next() -> Element? {
			nil
		}
		
	}
	
	// See protocol.
	public func makeAsyncIterator() -> AsyncIterator {
		.init()
	}
	
}
