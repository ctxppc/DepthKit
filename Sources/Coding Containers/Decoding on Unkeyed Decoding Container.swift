// DepthKit © 2017–2020 Constantino Tsarouhas

extension UnkeyedDecodingContainer {
	
	/// Decodes the next value, advancing the index if decoding succeeds.
	///
	/// - Throws: Any errors thrown while decoding the value.
	///
	/// - Returns: The decoded value.
	public mutating func decode<T : Decodable>() throws -> T {
		return try decode(T.self)
	}
	
	/// Decodes the next value, if present, advancing the index if a value is present and decoding succeeds.
	///
	/// - Throws: Any errors thrown while decoding the value.
	///
	/// - Returns: The decoded value, or `nil` if the value is `nil` or if the container does not have a value associated with `key`.
	public mutating func decodeIfPresent<T : Decodable>() throws -> T? {
		return try decodeIfPresent(T.self)
	}
	
}
