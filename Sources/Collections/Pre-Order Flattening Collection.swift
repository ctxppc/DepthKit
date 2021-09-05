// DepthKit © 2017–2021 Constantino Tsarouhas

/// A bidirectional collection that flattens a recursive bidirectional collection by visiting all subcollections in pre-order.
public struct PreOrderFlatteningBidirectionalCollection<RecursiveCollection : BidirectionalCollection> where RecursiveCollection.Element == RecursiveCollection {
	
	/// Creates a flattening collection over a collection.
	///
	/// - Parameters:
	///    - root: The root collection that is being flattened.
	///    - isLeaf: A function that determines whether a collection is a leaf node, given the collection and its index path within `root`. The default value is the constant false function.
	public init(root: RecursiveCollection, isLeaf: @escaping LeafPredicate = { _, _ in false }) {
		self.root = root
		self.isLeaf = isLeaf
	}
	
	/// The root collection that is being flattened.
	public let root: RecursiveCollection
	
	/// A function that determines whether a collection is a leaf node, given the collection and its index path within `root`.
	public let isLeaf: LeafPredicate
	public typealias LeafPredicate = (Element, Index.Path) -> Bool
	
}

extension PreOrderFlatteningBidirectionalCollection {
	
	/// Creates a flattening collection over a collection.
	///
	/// - Parameters:
	///    - root: The root collection that is being flattened.
	///    - maximumDepth: The maximum depth, inclusive. The root collection is at depth 0. If negative, the flattening collection is empty.
	public init(root: RecursiveCollection, maximumDepth: Int) {
		self.init(root: root, isLeaf: { _, path in path.count >= maximumDepth })
	}
	
}

extension PreOrderFlatteningBidirectionalCollection : BidirectionalCollection {
	
	public enum Index {
		
		public typealias Path = [RecursiveCollection.Index]
		
		/// A position to a nested collection.
		///
		/// - Invariant: The index path doesn't contain an end index or any other invalid indices for their associated collections.
		///
		/// - Parameter indexPath: The index path to the nested collection. The empty path refers to the base collection. The length of the path is the depth.
		case some(indexPath: Path)
		
		/// The position after the last element of a flattening collection.
		case end
		
	}
	
	public var startIndex: Index {
		.some(indexPath: [])
	}
	
	public var endIndex: Index {
		.end
	}
	
	public subscript (index: Index) -> RecursiveCollection {
		guard case .some(indexPath: let indexPath) = index else { preconditionFailure("Index out of bounds") }
		return self[indexPath]
	}
	
	/// Accesses the collection at given index path.
	///
	/// - Parameter indexPath: The index path. The empty path refers to root.
	private subscript <IndexPath : Sequence>(indexPath: IndexPath) -> RecursiveCollection where IndexPath.Element == RecursiveCollection.Index {
		indexPath.reduce(root) { (subcollection, index) in
			subcollection[index]
		}
	}
	
	public func index(before index: Index) -> Index {
		
		guard case .some(indexPath: let indexPath) = index else {
			return .some(indexPath: indexPathOfLastChild(at: []))
		}
		
		guard let (indexPathOfParent, indexOfCurrent) = indexPath.splittingLast() else { preconditionFailure("Index out of bounds") }
		
		let parent = self[indexPathOfParent]
		if indexOfCurrent > parent.startIndex {
			let indexPathOfSibling = Array(indexPathOfParent).appending(parent.index(before: indexOfCurrent))
			return .some(indexPath: indexPathOfLastChild(at: indexPathOfSibling))
		} else {
			return .some(indexPath: Array(indexPathOfParent))
		}
		
	}
	
	public func index(after index: Index) -> Index {
		
		guard case .some(indexPath: let indexPath) = index else { preconditionFailure("Index out of bounds") }
		
		if let indexPathOfFirstChild = indexPathOfFirstChild(at: indexPath) {
			return .some(indexPath: indexPathOfFirstChild)
		}
		
		for (indexPathOfParent, indexOfCurrent) in indexPath.unfoldingBackward() {	// indexPathOfParent becomes empty when parent is the root; root itself never is current
			let parent = self[indexPathOfParent]
			let indexOfSibling = parent.index(after: indexOfCurrent)
			if indexOfSibling < parent.endIndex {
				return .some(indexPath: Array(indexPathOfParent).appending(indexOfSibling))
			}
		}
		
		return .end
		
	}
	
	/// Returns the index path for the first child contained within the collection at a given index path.
	///
	/// - Parameter indexPathOfParent: The index path of the parent collection.
	///
	/// - Returns: The index path for the first child contained within the collection at `indexPathOfParent`; or `nil` if the collection at `indexPathOfParent` is empty or is a leaf node.
	private func indexPathOfFirstChild(at indexPathOfParent: Index.Path) -> Index.Path? {
		
		let parent = self[indexPathOfParent]	// TODO: Remove redundant computations of the parent in a recursive context.
		guard !isLeaf(parent, indexPathOfParent) else { return nil }
		
		guard let indexForFirstChild = parent.indices.first else { return nil }
		return indexPathOfParent.appending(indexForFirstChild)
		
	}
	
	/// Returns the index path for the last child contained within the collection at a given index path.
	///
	/// - Parameter indexPath: The index path to the parent collection.
	///
	/// - Returns: The index path for the last child contained within the collection at `indexPath`; or `indexPath` if the collection at `indexPath` is empty or is a leaf node.
	private func indexPathOfLastChild(at indexPathOfParent: Index.Path) -> Index.Path {
		
		let parent = self[indexPathOfParent]	// TODO: Remove redundant computations of the parent in a recursive context.
		guard !isLeaf(parent, indexPathOfParent) else { return indexPathOfParent }
		
		guard let indexOfLastChild = parent.indices.last else { return indexPathOfParent }
		return indexPathOfLastChild(at: indexPathOfParent.appending(indexOfLastChild))
		
	}
	
}

extension PreOrderFlatteningBidirectionalCollection.Index : Comparable {
	public static func < (earlier: Self, later: Self) -> Bool {
		switch (earlier, later) {
			case (.some(indexPath: let leftPath), .some(indexPath: let rightPath)):	return leftPath.lexicographicallyPrecedes(rightPath)
			case (.some, .end):														return true
			default:																return false
		}
	}
}
