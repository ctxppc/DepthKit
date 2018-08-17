// DepthKit © 2017–2018 Constantino Tsarouhas

extension RangeReplaceableCollection {
	
	/// Inserts an element repeatedly at a location in `self` until `self` reaches a certain number of elements.
	///
	/// The collection isn't changed if `self` has fewer than `targetCount` elements.
	///
	/// - Complexity: O(*n* × `targetCount`), where *n* is the length of the collection.
	///
	/// - Requires: `index` is an index to an element in `self`, or equal to `endIndex`.
	///
	/// - Parameter index: The index in `self` in which to insert padding.
	/// - Parameter padding: The element to insert repeatedly at `index`.
	/// - Parameter targetCount: The length of the collection after padding.
	public mutating func pad(at index: Index, with padding: Element, toCount targetCount: Int) {
		while targetCount > count {
			insert(padding, at: index)	// FIXME: index may become invalid after the first insertion
		}
	}
	
	/// Returns a copy of `self` after inserting an element repeatedly at a location until `self` reaches a certain number of elements.
	///
	/// The collection is returned unchanged if `self` has fewer than `targetCount` elements.
	///
	/// - Complexity: O(*n* × `targetCount`), where *n* is the length of the collection.
	///
	/// - Requires: `index` is an index to an element in `self`, or equal to `endIndex`.
	///
	/// - Parameter index: The index in `self` in which to insert padding.
	/// - Parameter padding: The element to insert repeatedly at `index`.
	/// - Parameter targetCount: The length of the collection after padding.
	///
	/// - Returns: A copy of `self` with zero or more insertions of `padding`.
	public func padded(at index: Index, with padding: Element, toCount targetCount: Int) -> Self {
		var collection = self
		collection.pad(at: index, with: padding, toCount: targetCount)
		return collection
	}
	
	/// Inserts a collection of elements repeatedly at a location in `self` until `self` reaches a certain number of elements.
	///
	/// If the difference in count isn't divible by the count of `padding`, the new count of `self` will exceed `targetCount`. The collection isn't changed if `self` has fewer than `targetCount` elements.
	///
	/// - Complexity: O(*n* × `targetCount`), where *n* is the length of the collection.
	///
	/// - Requires: `index` is an index to an element in `self`, or equal to `endIndex`.
	/// - Requires: `padding` is a non-empty collection.
	///
	/// - Parameter index: The index in `self` in which to insert padding.
	/// - Parameter padding: The elements to insert repeatedly at `index`.
	/// - Parameter targetCount: The length of the collection after padding.
	public mutating func pad<C : Collection>(at index: Index, withContentsOf padding: C, toCount targetCount: Int) where C.Element == Element {
		precondition(!padding.isEmpty, "Empty padding")
		while targetCount > count {
			insert(contentsOf: padding, at: index)	// FIXME: index may become invalid after the first insertion
		}
	}
	
	/// Returns a copy of `self` after inserting a collection of elements repeatedly at a location until `self` reaches a certain number of elements.
	///
	/// If the difference in count isn't divible by the count of `padding`, the count of the returned collection will exceed `targetCount`. The collection is returned unchanged if `self` has fewer than `targetCount` elements.
	///
	/// - Complexity: O(*n* × `targetCount`), where *n* is the length of the collection.
	///
	/// - Requires: `index` is an index to an element in `self`, or equal to `endIndex`.
	/// - Requires: `padding` is a non-empty collection.
	///
	/// - Parameter index: The index in `self` in which to insert padding.
	/// - Parameter padding: The elements to insert repeatedly at `index`.
	/// - Parameter targetCount: The length of the collection after padding.
	///
	/// - Returns: A copy of `self` with zero or more insertions of `padding`.
	public func padded<C : Collection>(at index: Index, withContentsOf padding: C, toCount targetCount: Int) -> Self where C.Element == Element {
		var collection = self
		collection.pad(at: index, withContentsOf: padding, toCount: targetCount)
		return collection
	}
	
}

extension Array {
	
	/// Inserts an element repeatedly at a location in `self` until `self` reaches a certain number of elements.
	///
	/// The array isn't changed if `self` has fewer than `targetCount` elements.
	///
	/// - Complexity: O(*n* + `targetCount`), where *n* is the length of the array.
	///
	/// - Requires: `index` is an index to an element in `self`, or equal to `endIndex`.
	///
	/// - Parameter index: The index in `self` in which to insert padding.
	/// - Parameter padding: The element to insert repeatedly at `index`.
	/// - Parameter targetCount: The length of the array after padding.
	public mutating func pad(at index: Index, with padding: Element, toCount targetCount: Int) {
		
		let insertionCount = targetCount - count
		guard insertionCount > 0 else { return }
		
		insert(contentsOf: repeatElement(padding, count: insertionCount), at: index)
		
	}
	
	/// Returns a copy of `self` after inserting an element repeatedly at a location until `self` reaches a certain number of elements.
	///
	/// The array is returned unchanged if `self` has fewer than `targetCount` elements.
	///
	/// - Complexity: O(*n* + `targetCount`), where *n* is the length of the array.
	///
	/// - Requires: `index` is an index to an element in `self`, or equal to `endIndex`.
	///
	/// - Parameter index: The index in `self` in which to insert padding.
	/// - Parameter padding: The element to insert repeatedly at `index`.
	/// - Parameter targetCount: The length of the array after padding.
	///
	/// - Returns: A copy of `self` with zero or more insertions of `padding`.
	public func padded(at index: Index, with padding: Element, toCount targetCount: Int) -> Array {
		var array = self
		array.pad(at: index, with: padding, toCount: targetCount)
		return array
	}
	
	/// Inserts a collection of elements repeatedly at a location in `self` until `self` reaches a certain number of elements.
	///
	/// If the difference in count isn't divible by the count of `padding`, the new count of `self` will exceed `targetCount`. The array isn't changed if `self` has fewer than `targetCount` elements.
	///
	/// - Complexity: O(*n* + `targetCount`), where *n* is the length of the array.
	///
	/// - Requires: `index` is an index to an element in `self`, or equal to `endIndex`.
	/// - Requires: `padding` is a non-empty collection.
	///
	/// - Parameter index: The index in `self` in which to insert padding.
	/// - Parameter padding: The elements to insert repeatedly at `index`.
	/// - Parameter targetCount: The length of the array after padding.
	public mutating func pad<C : Collection>(at index: Index, withContentsOf padding: C, toCount targetCount: Int) where C.Element == Element {
		
		precondition(!padding.isEmpty, "Empty padding")
		
		let paddingElementCount = targetCount - count
		guard paddingElementCount > 0 else { return }
		
		let (minimalInsertionCount, overshoot) = paddingElementCount.quotientAndRemainder(dividingBy: Int(padding.count))
		let insertionCount = overshoot == 0 ? minimalInsertionCount : minimalInsertionCount + 1
		
		insert(contentsOf: repeatElement(padding, count: insertionCount).joined(), at: index)
		
	}
	
	/// Returns a copy of `self` after inserting a collection of elements repeatedly at a location until `self` reaches a certain number of elements.
	///
	/// If the difference in count isn't divible by the count of `padding`, the count of the returned array will exceed `targetCount`. The array is returned unchanged if `self` has fewer than `targetCount` elements.
	///
	/// - Complexity: O(*n* + `targetCount`), where *n* is the length of the array.
	///
	/// - Requires: `index` is an index to an element in `self`, or equal to `endIndex`.
	/// - Requires: `padding` is a non-empty collection.
	///
	/// - Parameter index: The index in `self` in which to insert padding.
	/// - Parameter padding: The elements to insert repeatedly at `index`.
	/// - Parameter targetCount: The length of the array after padding.
	///
	/// - Returns: A copy of `self` with zero or more insertions of `padding`.
	public func padded<C : Collection>(at index: Index, withContentsOf padding: C, toCount targetCount: Int) -> Array where C.Element == Element {
		var array = self
		array.pad(at: index, withContentsOf: padding, toCount: targetCount)
		return array
	}
	
}
