// DepthKit © 2017 Constantino Tsarouhas

/// A bidirectional collection that flattens a recursive bidirectional collection by visiting all subcollections in level-order.
public struct LevelOrderFlatteningBidirectionalCollection<RecursiveCollection : BidirectionalCollection> where RecursiveCollection.Element == RecursiveCollection, RecursiveCollection.Indices : BidirectionalCollection {
	
	/// Creates a flattening collection over a collection.
	///
	/// - Parameter root: The root collection that is being flattened.
	/// - Parameter isLeaf: A function that determines whether a collection is a leaf node, given that collection's index path. The default always returns false.
	fileprivate init(root: RecursiveCollection, isLeaf: @escaping (Index.Path) -> Bool = { _ in false }) {
		self.root = root
		self.isLeaf = isLeaf
	}
	
	/// The root collection that is being flattened.
	public let root: RecursiveCollection
	
	/// A function that determines whether a collection is a leaf node, given the index path of the node.
	public let isLeaf: (Index.Path) -> Bool
	
}

extension LevelOrderFlatteningBidirectionalCollection {
	
	/// Creates a flattening collection over a collection.
	///
	/// - Parameter root: The root collection that is being flattened.
	/// - Parameter maximumDepth: The maximum depth, inclusive. The root collection is at depth 0. If negative, the flattening collection is empty.
	fileprivate init(root: RecursiveCollection, maximumDepth: Int) {
		self.init(root: root, isLeaf: { path in path.count <= maximumDepth })
	}
	
}

extension LevelOrderFlatteningBidirectionalCollection : BidirectionalCollection {
	
	public enum Index {
		
		public typealias Path = [RecursiveCollection.Index]
		
		/// A position to a nested collection.
		///
		/// - Invariant: The index path doesn't contain an end index or any other invalid indices for their associated collections.
		///
		/// - Parameter indexPath: The index path to the nested collection. The empty path refers to the base collection. The length of the path is the depth.
		case some(indexPath: Path)
		
		/// The position after the last element of the flattening collection.
		case end
		
	}
	
	public var startIndex: Index {
		return .some(indexPath: [])
	}
	
	public var endIndex: Index {
		return .end
	}
	
	public subscript (index: Index) -> RecursiveCollection {
		guard case .some(indexPath: let indexPath) = index else { preconditionFailure("Index out of bounds") }
		return self[indexPath]
	}
	
	/// Accesses the collection at given index path.
	///
	/// - Parameter indexPath: The index path. The empty path refers to root.
	private subscript <IndexPath : Sequence> (indexPath: IndexPath) -> RecursiveCollection where IndexPath.Element == RecursiveCollection.Index {
		return indexPath.reduce(root) { (subcollection, index) in
			subcollection[index]
		}
	}
	
	public func index(before index: Index) -> Index {
		
		guard case .some(indexPath: let indexPathOfCurrent) = index else { return .some(indexPath: lastDeepestIndexPath()) }
		precondition(!indexPathOfCurrent.isEmpty, "Index out of bounds")
		
		if let previousIndexPath = equidistantIndexPath(before: indexPathOfCurrent) {
			return .some(indexPath: previousIndexPath)
		}
		
		let previousDepth = indexPathOfCurrent.count - 1
		guard let indexPath = lastIndexPath(depth: previousDepth) else { fatalError("Previous depth doesn't exist") }
		return .some(indexPath: indexPath)
		
	}
	
	public func index(after index: Index) -> Index {
		
		guard case .some(indexPath: let indexPathOfCurrent) = index else { preconditionFailure("Index out of bounds") }
		
		if let nextIndexPath = equidistantIndexPath(after: indexPathOfCurrent) {
			return .some(indexPath: nextIndexPath)
		}
		
		guard let nextIndexPath = firstIndexPath(depth: indexPathOfCurrent.count + 1) else { return .end }
		return .some(indexPath: nextIndexPath)
		
	}
	
	/// Returns the previous index path that is at the same depth as a given index path.
	///
	/// - Parameter indexPath: The index path whose sibling or cousin to determine.
	///
	/// - Returns: The previous index path that is at the same depth as `indexPath`, or `nil` if there is no such index path.
	private func equidistantIndexPath<IndexPath : BidirectionalCollection>(before indexPath: IndexPath) -> Index.Path? where IndexPath.Element == RecursiveCollection.Index {
		
		// Determine index path of parent and index of "self", or fail if we're root.
		guard let (indexPathOfParentAsSlice, deepestIndex) = indexPath.splittingLast() else { return nil }
		let indexPathOfParent = Array(indexPathOfParentAsSlice)
		
		// Try sibling.
		let parent = self[indexPathOfParent]
		if deepestIndex > parent.startIndex {
			let indexOfSibling = parent.index(before: deepestIndex)
			return indexPathOfParent.appending(indexOfSibling)
		}
		
		// Try finding cousin (out of every sibling or cousin of the parent of "self").
		guard let indexPathOfPreviousParent = equidistantIndexPath(before: indexPathOfParent) else { return nil }
		for indexPathOfParent in sequence(first: indexPathOfPreviousParent, next: self.equidistantIndexPath(before:)) {
			let parent = self[indexPathOfParent]	// TODO: Potentially optimise redundant computations
			if let deepestIndex = parent.indices.last {
				return indexPathOfParent.appending(deepestIndex)
			}
		}
		
		// No cousin found.
		return nil
		
	}
	
	/// Returns the next index path that is at the same depth as a given index path.
	///
	/// - Parameter indexPath: The index path whose sibling or cousin to determine.
	///
	/// - Returns: The next index path that is at the same depth as `indexPath`, or `nil` if there is no such index path.
	private func equidistantIndexPath<IndexPath : BidirectionalCollection>(after indexPath: IndexPath) -> Index.Path? where IndexPath.Element == RecursiveCollection.Index {
		
		// Determine index path of parent and index of "self", or fail if we're root.
		guard let (indexPathOfParentAsSlice, deepestIndex) = indexPath.splittingLast() else { return nil }
		let indexPathOfParent = Array(indexPathOfParentAsSlice)
		
		// Try sibling.
		let parent = self[indexPathOfParent]
		let indexOfSibling = parent.index(after: deepestIndex)
		if indexOfSibling < parent.endIndex {
			return indexPathOfParent.appending(indexOfSibling)
		}
		
		// Try finding cousin (out of every sibling or cousin of the parent of "self").
		guard let indexPathOfNextParent = equidistantIndexPath(after: indexPathOfParent) else { return nil }
		for indexPathOfParent in sequence(first: indexPathOfNextParent, next: self.equidistantIndexPath(after:)) {
			let parent = self[indexPathOfParent]	// TODO: Potentially optimise redundant computations
			if let deepestIndex = parent.indices.first {
				return indexPathOfParent.appending(deepestIndex)
			}
		}
		
		// No cousin found.
		return nil
		
	}
	
	/// Returns the first index path at some depth.
	///
	/// - Requires: `depth >= 0`
	///
	/// - Parameter depth: The depth of the index path.
	///
	/// - Returns: The first index path at `depth`, with length `depth`.
	private func firstIndexPath(depth: Int) -> Index.Path? {
		
		assert(depth >= 0)
		
		if depth == 0 {
			return []
		}
		
		func firstIndexPath(within collection: RecursiveCollection, depthOfChildren: Int) -> Index.Path? {
			
			if depthOfChildren == depth {
				guard let firstIndex = collection.indices.first else { return nil }
				return [firstIndex]
			}
			
			for childIndex in collection.indices {
				let child = collection[childIndex]
				if let innerIndexPath = firstIndexPath(within: child, depthOfChildren: depthOfChildren + 1) {
					return [childIndex] + innerIndexPath
				}
			}
			
			return nil
			
		}
		
		return firstIndexPath(within: root, depthOfChildren: 1)
		
	}
	
	/// Returns the last index path at some depth.
	///
	/// - Requires: `depth >= 0`
	///
	/// - Parameter depth: The depth of the index path.
	///
	/// - Returns: The last index path at `depth`, with length `depth`.
	private func lastIndexPath(depth: Int) -> Index.Path? {
		
		assert(depth >= 0)
		
		if depth == 0 {
			return []
		}
		
		func lastIndexPath(within collection: RecursiveCollection, depthOfChildren: Int) -> Index.Path? {
			
			if depthOfChildren == depth {
				guard let lastIndex = collection.indices.last else { return nil }
				return [lastIndex]
			}
			
			for childIndex in collection.indices.lazy.reversed() {
				let child = collection[childIndex]
				if let innerIndexPath = lastIndexPath(within: child, depthOfChildren: depthOfChildren + 1) {
					return [childIndex] + innerIndexPath
				}
			}
			
			return nil
			
		}
		
		return lastIndexPath(within: root, depthOfChildren: 1)
		
	}
	
	/// Returns the last index path at maximal depth.
	///
	/// - Returns: The last index path at maximal depth. If the root collection is empty, the empty path.
	private func lastDeepestIndexPath() -> Index.Path {
		
		func lastDeepestIndexPath(within collection: RecursiveCollection) -> Index.Path {
			
			var deepestIndexPath = Index.Path()
			
			for childIndex in collection.indices.lazy.reversed() {
				let child = collection[childIndex]
				let candidateIndexPath = lastDeepestIndexPath(within: child)
				if candidateIndexPath.count + 1 > deepestIndexPath.count {
					deepestIndexPath = [childIndex] + candidateIndexPath
				}
			}
			
			return deepestIndexPath
			
		}
		
		return lastDeepestIndexPath(within: root)
		
	}
	
	// TODO: Implement more efficient (queue-based) iterator

}

extension LevelOrderFlatteningBidirectionalCollection.Index : Comparable {
	
	public static func <<C>(earlierIndex: LevelOrderFlatteningBidirectionalCollection<C>.Index, laterIndex: LevelOrderFlatteningBidirectionalCollection<C>.Index) -> Bool {
		
		switch (earlierIndex, laterIndex) {
			
			case (.some(indexPath: let earlierPath), .some(indexPath: let laterPath)):
			if earlierPath.count < laterPath.count {
				return true
			} else if earlierPath.count > laterPath.count {
				return false
			} else {
				return earlierPath.lexicographicallyPrecedes(laterPath)
			}
			
			case (.some, .end):
			return true
			
			default:
			return false
			
		}
		
	}
	
	public static func ==<C>(index: LevelOrderFlatteningBidirectionalCollection<C>.Index, otherIndex: LevelOrderFlatteningBidirectionalCollection<C>.Index) -> Bool {
		switch (index, otherIndex) {
			case (.some(indexPath: let path), .some(indexPath: let otherPath)):	return path == otherPath
			case (.end, .end):													return true
			default:															return false
		}
	}
	
}

extension BidirectionalCollection where Element == Self, Indices : BidirectionalCollection {
	
	/// Returns a level-order flattening collection over the collection.
	///
	/// - Parameter isLeaf: A function that determines whether a collection is a leaf node, given that collection's index path. The default always returns false.
	///
	/// - Returns: A level-order flattening collection over `self`.
	public func flattenedInLevelOrder(isLeaf: @escaping (LevelOrderFlatteningBidirectionalCollection<Self>.Index.Path) -> Bool = { _ in false }) -> LevelOrderFlatteningBidirectionalCollection<Self> {
		return LevelOrderFlatteningBidirectionalCollection(root: self, isLeaf: isLeaf)
	}
	
	/// Returns a level-order flattening collection over the collection.
	///
	/// - Parameter maximumDepth: The maximum depth, inclusive. `self` is at depth 0. If negative, the flattening collection is empty.
	///
	/// - Returns: A level-order flattening collection over `self`.
	public func flattenedInLevelOrder(maximumDepth: Int) -> LevelOrderFlatteningBidirectionalCollection<Self> {
		return LevelOrderFlatteningBidirectionalCollection(root: self, maximumDepth: maximumDepth)
	}
	
}
