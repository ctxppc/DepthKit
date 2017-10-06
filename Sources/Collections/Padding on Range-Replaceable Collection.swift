// DepthKit © 2017 Constantino Tsarouhas

extension RangeReplaceableCollection {
	
	/// Inserts an element repeatedly at a location in `self` until `self` reaches a certain number of elements.
	///
	/// The collection isn't changed if `self` has fewer than `targetCount` elements.
	///
	/// - Requires: `index` is an index to an element in `self`, or equal to `endIndex`.
	///
	/// - Parameter index: The index in `self` in which to insert padding.
	/// - Parameter padding: The element to insert repeatedly at `index`.
	/// - Parameter targetCount: The length of the collection after padding.
	public mutating func pad(at index: Index, with padding: Element, toCount targetCount: IndexDistance) {
		while targetCount > count {
			self.insert(padding, at: index)
		}
	}
	
	/// Returns a copy of `self` after inserting an element repeatedly at a location until `self` reaches a certain number of elements.
	///
	/// The collection is returned unchanged if `self` has fewer than `targetCount` elements.
	///
	/// - Requires: `index` is an index to an element in `self`, or equal to `endIndex`.
	///
	/// - Parameter index: The index in `self` in which to insert padding.
	/// - Parameter padding: The element to insert repeatedly at `index`.
	/// - Parameter targetCount: The length of the collection after padding.
	///
	/// - Returns: A copy of `self` with zero or more insertions of `padding`.
	public func padding(at index: Index, with padding: Element, toCount targetCount: IndexDistance) -> Self {
		var collection = self
		collection.pad(at: index, with: padding, toCount: targetCount)
		return collection
	}
	
	/// Inserts a collection of elements repeatedly at a location in `self` until `self` reaches a certain number of elements.
	///
	/// If the difference in count isn't divible by the count of `padding`, the new count of `self` will exceed `targetCount`. The collection isn't changed if `self` has fewer than `targetCount` elements.
	///
	/// - Requires: `index` is an index to an element in `self`, or equal to `endIndex`.
	/// - Requires: `padding` is a non-empty collection.
	///
	/// - Parameter index: The index in `self` in which to insert padding.
	/// - Parameter padding: The elements to insert repeatedly at `index`.
	/// - Parameter targetCount: The length of the collection after padding.
	public mutating func pad<C : Collection>(at index: Index, withContentsOf padding: C, toCount targetCount: IndexDistance) where C.Element == Element {
		precondition(!padding.isEmpty, "Empty padding")
		while targetCount > count {
			self.insert(contentsOf: padding, at: index)
		}
	}
	
	/// Returns a copy of `self` after inserting a collection of elements repeatedly at a location until `self` reaches a certain number of elements.
	///
	/// If the difference in count isn't divible by the count of `padding`, the count of the returned collection will exceed `targetCount`. The collection is returned unchanged if `self` has fewer than `targetCount` elements.
	///
	/// - Requires: `index` is an index to an element in `self`, or equal to `endIndex`.
	/// - Requires: `padding` is a non-empty collection.
	///
	/// - Parameter index: The index in `self` in which to insert padding.
	/// - Parameter padding: The elements to insert repeatedly at `index`.
	/// - Parameter targetCount: The length of the collection after padding.
	///
	/// - Returns: A copy of `self` with zero or more insertions of `padding`.
	public func padding<C : Collection>(at index: Index, withContentsOf padding: C, toCount targetCount: IndexDistance) -> Self where C.Element == Element {
		var collection = self
		collection.pad(at: index, withContentsOf: padding, toCount: targetCount)
		return collection
	}
	
}
