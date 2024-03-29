// DepthKit © 2017–2021 Constantino Tsarouhas

extension Comparable {
	
	/// Returns `self` if `self` is within `range`, otherwise returns the closest bound of `range`.
	///
	/// - Parameter range: The range of acceptable values.
	///
	/// - Returns: `range.lowerBound` if `self` ≤ `range.lowerBound`, `range.upperBound` if `self` ≥ `range.upperBound`, or `self` otherwise.
	public func capped(to range: ClosedRange<Self>) -> Self {
		max(range.lowerBound, min(range.upperBound, self))
	}
	
	/// Returns `self` if `self` is within `range`, otherwise returns the lower bound of `range`.
	///
	/// - Parameter range: The range of acceptable values.
	///
	/// - Returns: `range.lowerBound` if `self` ≤ `range.lowerBound`, otherwise `self`.
	public func capped(to range: PartialRangeFrom<Self>) -> Self {
		max(range.lowerBound, self)
	}
	
	/// Returns `self` if `self` is within `range`, otherwise returns the upper bound of `range`.
	///
	/// - Parameter range: The range of acceptable values.
	///
	/// - Returns: `range.upperBound` if `self` ≥ `range.upperBound`, otherwise `self`.
	public func capped(to range: PartialRangeThrough<Self>) -> Self {
		min(range.upperBound, self)
	}
	
}
