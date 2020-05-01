// DepthKit © 2017–2020 Constantino Tsarouhas

extension BidirectionalCollection {
	
	/// Returns the last element and the other elements of the collection, separately.
	///
	/// - Complexity: O(1)
	///
	/// - Returns: The last element `tail` of `self` and the subsequence `head` of elements that precede `tail` in `self`; or `nil` if `self` is empty.
	public func splittingLast() -> (head: SubSequence, tail: Element)? {
		guard let tail = last else { return nil }
		return (head: prefix(upTo: index(before: endIndex)), tail: tail)
	}
	
}

extension BidirectionalCollection where SubSequence : BidirectionalCollection {
	
	/// Returns a sequence over every element, from the last to the first, and the subsequence of elements preceding that element.
	///
	/// - Returns: A sequence of every element `tail` in `self`, from the last to the first, and the subsequence `head` of elements that precede `tail` in `self`.
	public func unfoldingBackward() -> UnfoldSequence<(SubSequence, Element), SubSequence> {
		return sequence(state: prefix(upTo: endIndex)) { (subsequence: inout SubSequence) in
			guard let (head, tail) = subsequence.splittingLast() else { return nil }
			subsequence = head
			return (head, tail)
		}
	}
	
}
