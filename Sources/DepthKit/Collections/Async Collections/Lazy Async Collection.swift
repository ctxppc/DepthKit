// Protocol © 2024 Constantino Tsarouhas

/// A collection that asynchronously and lazily computes its elements.
///
/// Although a lazy asynchronous collection's elements are computed lazily, they **do not change** between suspension points. Collections that rely on a changing external source may use techniques such as snapshots or transactions to ensure that its view of the data does not change while the collection is in use. A collection may become invalid if it loses access to its fixed view of the data, at which point every element access may throw an error.
///
/// A lazy asynchronous collection does not necessarily cache its elements. `LazyAsyncCollection` does not specify any caching behaviour.
///
/// A lazy asynchronous collection supports bidirectional synchronous index traversal, similar to `BidirectionalCollection` (except that element access is asynchronous and can throw errors).
public protocol LazyAsyncCollection<Element, Failure> : AsyncSequence {
	
	// See protocol.
	associatedtype AsyncIterator = LazyAsyncCollectionIterator<Self>
	
	/// A value that represents a position in a collection.
	///
	/// An index either refers to an element in the collection (a *valid* index) or to the position after the last element in the collection (a *past the end* index).
	associatedtype Index : Comparable
	
	/// The index of the first element, or `endIndex` if the collection is empty.
	var startIndex: Index { get }
	
	/// The index after the index of the last element.
	var endIndex: Index { get }
	
	/// Returns the index of the element preceding the element of given index.
	func index(before index: Index) -> Index
	
	/// Returns the index of the element following the element of given index.
	func index(after index: Index) -> Index
	
	/// Returns an index that is given distance from given index.
	///
	/// The default implementation invokes `index(before:)` or `index(after:)` repeatedly unless `Index` is `Strideable`.
	func index(_ index: Index, offsetBy distance: Int) -> Index
	
	/// Returns an index that is given distance from given index, unless that distance is beyond given limiting index.
	///
	/// The default implementation invokes `index(before:)` or `index(after:)` repeatedly unless `Index` is `Strideable`.
	func index(_ index: Index, offsetBy distance: Int, limitedBy limit: Index) -> Index?
	
	/// Returns the distance between given indices.
	///
	/// The default implementation invokes `index(before:)` or `index(after:)` repeatedly unless `Index` is `Strideable`.
	func distance(from start: Index, to end: Index) -> Int
	
	/// A collection of valid, consecutive indices in a collection, in ascending order.
	associatedtype Indices : BidirectionalCollection<Index> = LazyAsyncCollectionIndices<Self> where Indices.SubSequence == Indices
	
	/// The indices that refer to elements in the collection, in ascending order.
	var indices: Indices { get }
	
	/// A Boolean value indicating whether the collection is empty.
	///
	/// The default implementation returns `true` iff `startIndex` is equal to `endIndex`.
	///
	/// - Complexity: O(1).
	var isEmpty: Bool { get }
	
	/// The number of elements in the collection.
	///
	/// The default implementation returns `indices.count`.
	///
	/// - Complexity: O(*n*).
	var count: Int { get }
	
	/// Accesses the element at given position.
	subscript (position: Index) -> Element {
		get async throws(Failure)
	}
	
	/// A collection representing a contiguous subrange of the collection's elements, with indices in the subsequence corresponding to indices in the original collection.
	associatedtype SubSequence : LazyAsyncCollection<Element, Failure> where SubSequence.Index == Index, SubSequence.SubSequence == SubSequence
	
	/// Accesses the elements at given positions.
	///
	/// The elements in the returned subsequence are lazily computed.
	///
	/// The default implementation returns a lazy asynchronous slice.
	subscript (positions: Range<Index>) -> SubSequence { get }
	
}

extension LazyAsyncCollection {
	
	public func index(_ index: Index, offsetBy distance: Int) -> Index {
		var index = index
		if distance > 0 {
			for _ in 1...distance {
				index = self.index(after: index)
			}
		} else if distance < 0 {
			for _ in 1...distance {
				index = self.index(before: index)
			}
		}
		precondition((startIndex..<endIndex).contains(index), "No valid index \(distance) removed from \(index)")
		return index
	}
	
	public func index(_ index: Index, offsetBy distance: Int, limitedBy limit: Index) -> Index? {
		var index = index
		if distance > 0 {
			for _ in 1...distance {
				guard index < limit else { return nil }
				index = self.index(after: index)
			}
		} else if distance < 0 {
			for _ in 1...distance {
				guard index > limit else { return nil }
				index = self.index(before: index)
			}
		}
		return index
	}
	
	public func distance(from start: Index, to end: Index) -> Int {
		return if start > end {
			LazyAsyncCollectionIndices(elements: self, bounds: start..<end).count
		} else if end < start {
			-LazyAsyncCollectionIndices(elements: self, bounds: end..<start).count
		} else {
			0
		}
	}
	
	public var isEmpty: Bool {
		startIndex == endIndex
	}
	
	public var count: Int {
		distance(from: startIndex, to: endIndex)
	}
	
	/// The first element, or `nil` if the collection is empty.
	public var first: Element? {
		get async throws(Failure) {
			isEmpty ? nil : try await self[startIndex]
		}
	}
	
	/// Accesses the entire collection.
	public subscript (_: UnboundedRange) -> SubSequence {
		self[startIndex..<endIndex]
	}
	
}

extension LazyAsyncCollection where Index : Strideable, Index.Stride == Int {
	
	public func index(before index: Index) -> Index {
		self.index(index, offsetBy: -1)
	}
	
	public func index(after index: Index) -> Index {
		self.index(index, offsetBy: +1)
	}
	
	public func index(_ index: Index, offsetBy distance: Int) -> Index {
		let result = index.advanced(by: distance)
		precondition((startIndex..<endIndex).contains(result), "No valid index \(distance) removed from \(index)")
		return result
	}
	
	public func index(_ index: Index, offsetBy distance: Int, limitedBy limit: Index) -> Index? {
		let result = index.advanced(by: distance)
		return (distance > 0 && index <= limit) || (distance < 0 && result > limit) || distance == 0
			? result
			: nil
	}
	
	public func distance(from start: Index, to end: Index) -> Int {
		start.distance(to: end)
	}
	
}

public struct LazyAsyncCollectionIndices<Elements : LazyAsyncCollection> : BidirectionalCollection {
	
	/// Creates a collection of indices for given collection.
	fileprivate init(elements: Elements) {
		self.init(elements: elements, bounds: elements.startIndex..<elements.endIndex)
	}
	
	/// Creates a collection of indices for given collection and within given bounds.
	fileprivate init(elements: Elements, bounds: Range<Index>) {
		self.elements = elements
		self.startIndex = bounds.lowerBound
		self.endIndex = bounds.upperBound
	}
	
	/// The collection.
	fileprivate let elements: Elements
	
	// See protocol.
	public typealias Index = Elements.Index
	
	// See protocol.
	public let startIndex: Index
	
	// See protocol.
	public let endIndex: Index
	
	// See protocol.
	public func index(before index: Index) -> Index {
		precondition(index > startIndex, "\(index) does not a predecessor in \(self)")
		return elements.index(before: index)
	}
	
	// See protocol.
	public func index(after index: Index) -> Index {
		precondition(index <= endIndex, "\(index) does not have a successor in \(self)")
		return elements.index(after: index)
	}
	
	// See protocol.
	public subscript (position: Index) -> Index {
		precondition((startIndex..<endIndex).contains(position), "\(self) does not contain \(position)")
		return position
	}
	
	// See protocol.
	public subscript (positions: Range<Index>) -> Self {
		precondition(positions.lowerBound >= startIndex && positions.upperBound <= endIndex, "\(positions) is not a subset of \(self)")
		return .init(elements: elements, bounds: positions)
	}
	
}

extension LazyAsyncCollection where Indices == LazyAsyncCollectionIndices<Self> {
	public var indices: Indices {
		.init(elements: self)
	}
}

public struct LazyAsyncSlice<Base : LazyAsyncCollection> : LazyAsyncCollection {
	
	public typealias Element = Base.Element
	public typealias Failure = Base.Failure
	public typealias Index = Base.Index
	public typealias SubSequence = Self
	
	/// The original collection.
	public let base: Base
	
	// See protocol.
	public private(set) var startIndex: Index
	
	// See protocol.
	public private(set) var endIndex: Index
	
	// See protocol.
	public func index(before index: Index) -> Index {
		base.index(before: index)
	}
	
	// See protocol.
	public func index(after index: Index) -> Index {
		base.index(after: index)
	}
	
	// See protocol.
	public subscript (position: Index) -> Element {
		get async throws(Failure) {
			try await base[position]
		}
	}
	
	// See protocol.
	public subscript(positions: Range<Index>) -> SubSequence {
		.init(base: base, startIndex: positions.lowerBound, endIndex: positions.upperBound)
	}
	
}

public struct LazyAsyncCollectionIterator<Elements : LazyAsyncCollection> : AsyncIteratorProtocol {
	
	public typealias Element = Elements.Element
	public typealias Failure = Elements.Failure
	
	/// Creates an iterator over given lazy asynchronous collection.
	fileprivate init(over elements: Elements) {
		remainingElements = elements[...]
	}
	
	/// The elements remaining in the iterator.
	private var remainingElements: Elements.SubSequence
	
	// See protocol.
	public mutating func next() async throws(Failure) -> Element? {
		guard let first = try await remainingElements.first else { return nil }
		remainingElements = remainingElements[remainingElements.index(after: remainingElements.startIndex)..<remainingElements.endIndex]
		return first
	}
	
	
}

extension LazyAsyncCollection where AsyncIterator == LazyAsyncCollectionIterator<Self> {
	public func makeAsyncIterator() -> AsyncIterator {
		.init(over: self)
	}
}
