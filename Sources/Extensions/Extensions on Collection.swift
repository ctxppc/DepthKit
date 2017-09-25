// DepthKit © 2017 Constantino Tsarouhas

extension Collection {
	
	/// Returns the first element and the other elements of the collection, separately.
	///
	/// - Complexity: O(1)
	///
	/// - Returns: The first element `head` of `self` and the subsequence `tail` of elements that follow `head` in `self`; or `nil` if `self` is empty.
	func splittingFirst() -> (head: Iterator.Element, tail: SubSequence)? {
		guard let head = first else { return nil }
		return (head: head, tail: suffix(from: index(after: startIndex)))
	}
	
}

extension Collection where SubSequence : Collection {
	
	/// Returns a sequence over every element and the subsequence of elements following that element.
	///
	/// - Returns: A sequence of every element `head` in `self` and the subsequence `tail` of elements that follow `head` in `self`.
	func unfoldingForward() -> UnfoldSequence<(Iterator.Element, SubSequence), SubSequence> {
		return sequence(state: suffix(from: startIndex)) { (subsequence: inout SubSequence) in
			guard let (head, tail) = subsequence.splittingFirst() else { return nil }
			subsequence = tail
			return (head, tail)
		}
	}
	
}
