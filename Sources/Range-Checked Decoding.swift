// DepthKit © 2017–2020 Constantino Tsarouhas

extension KeyedDecodingContainer {
	
	/// Decodes a value associated with given key & verifies whether the decoded value is within a given range.
	///
	/// - Parameter key: The key associated with the value to decode.
	/// - Parameter range: The range of valid values for the decoded value.
	///
	/// - Returns: The value in `self` associated with `key`.
	///
	/// - Throws: A decoding error if `self` doesn't contain `key`, if the decoded value can't be represented as `T`, or if `range` doesn't contain the decoded value.
	public func decode<T : Decodable, R : RangeExpression>(_ type: T, forKey key: Key, range: R) throws -> T where R.Bound == T {
		try decode(key: key, range: range)
	}
	
	/// Decodes a value associated with given key & verifies whether the decoded value is within a given range.
	///
	/// - Parameter key: The key associated with the value to decode.
	/// - Parameter range: The range of valid values for the decoded value.
	///
	/// - Returns: The value in `self` associated with `key`.
	///
	/// - Throws: A decoding error if `self` doesn't contain `key`, if the decoded value can't be represented as `T`, or if `range` doesn't contain the decoded value.
	public func decode<T : Decodable, R : RangeExpression>(key: Key, range: R) throws -> T where R.Bound == T {
		let value = try decode(T.self, forKey: key)
		guard range.contains(value) else { throw DecodingError.dataCorruptedError(forKey: key, in: self, debugDescription: "Decoded value \(value) exceeds range \(range)") }
		return value
	}
	
}
