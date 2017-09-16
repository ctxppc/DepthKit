// DepthKit © 2017 Constantino Tsarouhas

extension RangeReplaceableCollection {
	
	/// Returns a copy of the collection with the contents of a given sequence appended to it.
	///
	/// - Parameter other: The sequence whose elements to append.
	///
	/// - Returns: A copy of the collection with the contents of `other` appended to it.
	public func appending(_ element: Iterator.Element) -> Self {
		return withCopy(of: self, mutator: Self.append, argument: element)
	}
	
	/// Returns a copy of the collection with the contents of a given sequence appended to it.
	///
	/// - Parameter other: The sequence whose elements to append.
	///
	/// - Returns: A copy of the collection with the contents of `other` appended to it.
	public func appending<S : Sequence>(contentsOf other: S) -> Self where S.Iterator.Element == Iterator.Element {
		return withCopy(of: self, mutator: Self.append, argument: other)
	}
	
	/// Returns a copy of the collection after inserting an element at a given index.
	///
	/// - Parameter insertedElement: The element to insert.
	/// - Parameter index: The index of the inserted element.
	///
	/// - Returns: A copy of `self` after inserting `insertedElement` at `index`.
	public func inserting(_ insertedElement: Iterator.Element, at index: Index) -> Self {
		return withCopy(of: self) { (collection: inout Self) in
			collection.insert(insertedElement, at: index)
		}
	}
	
	/// Returns a copy of the collection after removing an element at a given index.
	///
	/// - Parameter index: The index of the removed element.
	///
	/// - Returns: A copy of `self` after removing the element at `index`.
	public func removing(at index: Index) -> Self {
		return withCopy(of: self) { (collection: inout Self) in
			collection.remove(at: index)
		}
	}
	
}