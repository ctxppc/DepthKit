// DepthKit © 2017–2021 Constantino Tsarouhas

public final class BasicValueDecoder : Decoder {
	
	/// Creates a decoder with given decoded value.
	public init(value: Any) {
		self.value = value
		codingPath = []
		userInfo = [:]
		convertedKeyValue = { $0 }
	}
	
	/// Creates a decoder with given decoded value and coding path.
	internal init(from decoder: BasicValueDecoder, key: CodingKey, value: Any) {
		self.value = value
		codingPath = decoder.codingPath + [key]
		userInfo = decoder.userInfo
		convertedKeyValue = decoder.convertedKeyValue
	}
	
	/// The encoded value being decoded by `self`.
	private let value: Any
	
	// See protocol.
	public let codingPath: [CodingKey]
	
	// See protocol.
	public var userInfo: [CodingUserInfoKey : Any]
	
	/// A function that maps a key from a dictionary to the string value of a coding key.
	public var convertedKeyValue: (String) -> String
	
	// See protocol.
	public func container<Key : CodingKey>(keyedBy keyType: Key.Type) throws -> KeyedDecodingContainer<Key> {
		guard let dictionary = value as? [String : Any] else { throw DecodingError.typeMismatch([String : Any].self, DecodingError.Context(codingPath: codingPath, debugDescription: "Keyed container can only be created over dictionaries; got \(value) of type \(type(of: value)) instead.")) }
		return .init(KeyedBasicValueDecodingContainer(for: self, decoding: dictionary, at: codingPath))
	}
	
	// See protocol.
	public func unkeyedContainer() throws -> UnkeyedDecodingContainer {
		guard let array = value as? [Any] else { throw DecodingError.typeMismatch([Any].self, DecodingError.Context(codingPath: codingPath, debugDescription: "Unkeyed container can only be created over arrays; got \(value) of type \(type(of: value)) instead.")) }
		return UnkeyedBasicValueDecodingContainer(for: self, decoding: array, at: codingPath)
	}
	
	// See protocol.
	public func singleValueContainer() throws -> SingleValueDecodingContainer {
		SingleBasicValueDecodingContainer(value: value, codingPath: codingPath)
	}
	
	/// Decodes a value of some type.
	public func decode<T : Decodable>(_ type: T.Type = T.self) throws -> T {
		try T(from: self)
	}
	
}
