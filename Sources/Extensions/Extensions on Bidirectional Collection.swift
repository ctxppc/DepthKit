// DepthKit © 2017 Constantino Tsarouhas

extension BidirectionalCollection {
	
	/// Returns the last element and the other elements of the collection, separately.
	///
	/// - Complexity: O(1)
	///
	/// - Returns: The last element `tail` of `self` and the subsequence `head` of elements that precede `tail` in `self`; or `nil` if `self` is empty.
	public func splittingLast() -> (head: SubSequence, tail: Iterator.Element)? {
		guard let tail = last else { return nil }
		return (head: prefix(upTo: index(before: endIndex)), tail: tail)
	}
	
}

extension BidirectionalCollection where SubSequence : BidirectionalCollection {
	
	/// Returns a sequence over every element, from the last to the first, and the subsequence of elements preceding that element.
	///
	/// - Returns: A sequence of every element `tail` in `self`, from the last to the first, and the subsequence `head` of elements that precede `tail` in `self`.
	public func unfoldingBackward() -> UnfoldSequence<(SubSequence, Iterator.Element), SubSequence> {
		return sequence(state: prefix(upTo: endIndex)) { (subsequence: inout SubSequence) in
			guard let (head, tail) = subsequence.splittingLast() else { return nil }
			subsequence = head
			return (head, tail)
		}
	}
	
}

extension BidirectionalCollection where Iterator.Element : Equatable {
	
	/// Returns a Boolean value indicating whether the collection's last elements are the same as the elements from another collection.
	///
	/// - Parameter suffix: The elements.
	///
	/// - Returns: `true` if the last elements in `self` are `suffix`, otherwise `false`.
	public func ends<Suffix : BidirectionalCollection>(with suffix: Suffix) -> Bool where Suffix.Iterator.Element == Iterator.Element, Suffix.IndexDistance == IndexDistance {
		
		guard self.count >= suffix.count else { return false }
		
		for (element1, element2) in zip(suffix.reversed(), self.reversed()) {
			guard element1 == element2 else { return false }
		}
		
		return true
		
	}
	
}

extension BidirectionalCollection where Iterator.Element == Self {
	
	/// Returns a pre-order flattening collection over the collection.
	///
	/// - Parameter isLeaf: A function that determines whether a collection is a leaf node, given that collection's index path. The default always returns false.
	///
	/// - Returns: A pre-order flattening collection over `self`.
	public func flattenedInPreOrder(isLeaf: @escaping (PreOrderFlatteningBidirectionalCollection<Self>.Index.Path) -> Bool = { _ in false }) -> PreOrderFlatteningBidirectionalCollection<Self> {
		return PreOrderFlatteningBidirectionalCollection(root: self, isLeaf: isLeaf)
	}
	
	/// Returns a pre-order flattening collection over the collection.
	///
	/// - Parameter maximumDepth: The maximum depth, inclusive. `self` is at depth 0. If negative, the flattening collection is empty.
	///
	/// - Returns: A pre-order flattening collection over `self`.
	public func flattenedInPreOrder(maximumDepth: Int) -> PreOrderFlatteningBidirectionalCollection<Self> {
		return PreOrderFlatteningBidirectionalCollection(root: self, maximumDepth: maximumDepth)
	}
	
	/// Returns a post-order flattening collection over the collection.
	///
	/// - Parameter isLeaf: A function that determines whether a collection is a leaf node, given that collection's index path. The default always returns false.
	///
	/// - Returns: A post-order flattening collection over `self`.
	public func flattenedInPostOrder(isLeaf: @escaping (PostOrderFlatteningBidirectionalCollection<Self>.Index.Path) -> Bool = { _ in false }) -> PostOrderFlatteningBidirectionalCollection<Self> {
		return PostOrderFlatteningBidirectionalCollection(root: self, isLeaf: isLeaf)
	}
	
	/// Returns a post-order flattening collection over the collection.
	///
	/// - Parameter maximumDepth: The maximum depth, inclusive. `self` is at depth 0. If negative, the flattening collection is empty.
	///
	/// - Returns: A post-order flattening collection over `self`.
	public func flattenedInPostOrder(maximumDepth: Int) -> PostOrderFlatteningBidirectionalCollection<Self> {
		return PostOrderFlatteningBidirectionalCollection(root: self, maximumDepth: maximumDepth)
	}
	
}
