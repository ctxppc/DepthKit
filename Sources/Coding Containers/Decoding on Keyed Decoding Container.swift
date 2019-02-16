// DepthKit © 2017–2019 Constantino Tsarouhas

extension KeyedDecodingContainer {
	
	/// Decodes a value for given key.
	///
	/// - Parameter key: The key that the decoded value is associated with.
	///
	/// - Throws: Any errors thrown while decoding the value.
	///
	/// - Returns: The decoded value.
	public func decode<T : Decodable>(key: Key) throws -> T {
		return try decode(T.self, forKey: key)
	}
	
	/// Decodes a value for given key, if present.
	///
	/// - Parameter key: The key that the decoded value is associated with.
	///
	/// - Throws: Any errors thrown while decoding the value.
	///
	/// - Returns: The decoded value, or `nil` if the value is `nil` or if there are no more elements to be decoded.
	public func decodeIfPresent<T : Decodable>(key: Key) throws -> T? {
		return try decodeIfPresent(T.self, forKey: key)
	}
	
}
