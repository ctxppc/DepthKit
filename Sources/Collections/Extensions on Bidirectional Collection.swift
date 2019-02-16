// DepthKit © 2017–2019 Constantino Tsarouhas

extension BidirectionalCollection where Element : Equatable {
	
	/// Returns a Boolean value indicating whether the collection's last elements are the same as the elements from another collection.
	///
	/// - Parameter suffix: The elements.
	///
	/// - Returns: `true` if the last elements in `self` are `suffix`, otherwise `false`.
	public func ends<Suffix : BidirectionalCollection>(with suffix: Suffix) -> Bool where Suffix.Element == Element {
		
		guard self.count >= suffix.count else { return false }
		
		for (element1, element2) in zip(suffix.reversed(), self.reversed()) {
			guard element1 == element2 else { return false }
		}
		
		return true
		
	}
	
}

extension BidirectionalCollection where Element == Self {
	
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
