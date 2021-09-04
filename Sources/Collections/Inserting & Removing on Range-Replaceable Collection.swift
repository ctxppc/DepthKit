// DepthKit © 2017–2021 Constantino Tsarouhas

extension RangeReplaceableCollection {
	
	/// Returns a copy of the collection with the contents of a given sequence appended to it.
	///
	/// - Parameter other: The sequence whose elements to append.
	///
	/// - Returns: A copy of the collection with the contents of `other` appended to it.
	public func appending(_ element: Element) -> Self {
		with(self) {
			$0.append(element)
		}
	}
	
	/// Returns a copy of the collection with the contents of a given sequence appended to it.
	///
	/// - Parameter other: The sequence whose elements to append.
	///
	/// - Returns: A copy of the collection with the contents of `other` appended to it.
	public func appending<S : Sequence>(contentsOf other: S) -> Self where S.Element == Element {
		with(self) {
			$0.append(contentsOf: other)
		}
	}
	
	/// Returns a copy of the collection after inserting an element at a given index.
	///
	/// - Parameter insertedElement: The element to insert.
	/// - Parameter index: The index of the inserted element.
	///
	/// - Returns: A copy of `self` after inserting `insertedElement` at `index`.
	public func inserting(_ insertedElement: Element, at index: Index) -> Self {
		with(self) {
			$0.insert(insertedElement, at: index)
		}
	}
	
	/// Returns a copy of the collection after removing an element at a given index.
	///
	/// - Parameter index: The index of the removed element.
	///
	/// - Returns: A copy of `self` after removing the element at `index`.
	public func removing(at index: Index) -> Self {
		with(self) {
			$0.remove(at: index)
		}
	}
	
}
