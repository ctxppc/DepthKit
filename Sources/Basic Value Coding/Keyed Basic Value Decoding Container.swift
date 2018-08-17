// DepthKit © 2017–2018 Constantino Tsarouhas

public struct KeyedBasicValueDecodingContainer<Key : CodingKey> : KeyedDecodingContainerProtocol {
	
	/// Creates a decoding container with given backing dictionary and coding path.
	internal init(for decoder: BasicValueDecoder, decoding dictionary: [String : Any], at codingPath: [CodingKey]) {
		
		self.decoder = decoder
		self.dictionary = dictionary
		self.codingPath = codingPath
		
		allKeys = dictionary.keys.map(decoder.convertedKeyValue).compactMap(Key.init)
		
	}
	
	/// The backing dictionary.
	private let dictionary: [String : Any]
	
	/// The decoder that created the container.
	private let decoder: BasicValueDecoder
	
	// See protocol.
	public let codingPath: [CodingKey]
	
	// See protocol.
	public let allKeys: [Key]
	
	// See protocol.
	public func contains(_ key: Key) -> Bool {
		return dictionary.keys.contains(decoder.convertedKeyValue(key.stringValue))
	}
	
	// See protocol.
	public func decodeNil(forKey key: Key) throws -> Bool {
		let anyValue = try rawValue(forKey: key)
		guard let optional = anyValue as? OptionalProtocol else { return false }
		return optional.isNil
	}
	
	// See protocol.
	public func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
		return try decode(key: key)
	}
	
	// See protocol.
	public func decode(_ type: String.Type, forKey key: Key) throws -> String {
		return try decode(key: key)
	}
	
	// See protocol.
	public func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
		return try decode(key: key)
	}
	
	// See protocol.
	public func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
		return try decode(key: key)
	}
	
	// See protocol.
	public func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
		return try decode(key: key)
	}
	
	// See protocol.
	public func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
		return try decode(key: key)
	}
	
	// See protocol.
	public func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
		return try decode(key: key)
	}
	
	// See protocol.
	public func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
		return try decode(key: key)
	}
	
	// See protocol.
	public func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
		return try decode(key: key)
	}
	
	// See protocol.
	public func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
		return try decode(key: key)
	}
	
	// See protocol.
	public func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
		return try decode(key: key)
	}
	
	// See protocol.
	public func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
		return try decode(key: key)
	}
	
	// See protocol.
	public func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
		return try decode(key: key)
	}
	
	// See protocol.
	public func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
		return try decode(key: key)
	}
	
	private func decode<Integer : BinaryInteger & Decodable>(key: Key) throws -> Integer {
		return try integer(from: rawValue(forKey: key), codingPath: codingPath.appending(key))
	}
	
	private func decode<Number : BinaryFloatingPoint & Decodable>(key: Key) throws -> Number {
		return try number(from: rawValue(forKey: key), codingPath: codingPath.appending(key))
	}
	
	// See protocol.
	public func decode<T : Decodable>(_ type: T.Type, forKey key: Key) throws -> T {
		return try decode(key: key)
	}
	
	public func decode<T : Decodable>(key: Key) throws -> T {
		return try T(from: BasicValueDecoder(from: decoder, key: key, value: rawValue(forKey: key)))
	}
	
	// See protocol.
	public func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
		return try BasicValueDecoder(from: decoder, key: key, value: rawValue(forKey: key)).container(keyedBy: type)
	}
	
	// See protocol.
	public func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
		return try BasicValueDecoder(from: decoder, key: key, value: rawValue(forKey: key)).unkeyedContainer()
	}
	
	// See protocol.
	public func superDecoder() throws -> Decoder {
		return try superDecoder(forKey: BasicValueCodingKey.super)
	}
	
	// See protocol.
	public func superDecoder(forKey key: Key) throws -> Decoder {
		return try superDecoder(forKey: key as CodingKey)
	}
	
	// See protocol.
	private func superDecoder(forKey key: CodingKey) throws -> Decoder {
		return try BasicValueDecoder(from: decoder, key: key, value: rawValue(forKey: key))
	}
	
	private func rawValue(forKey key: CodingKey) throws -> Any {
		guard let value = dictionary[decoder.convertedKeyValue(key.stringValue)] else { throw DecodingError.keyNotFound(key, .init(codingPath: codingPath, debugDescription: "Key not found")) }
		return value
	}
	
}

internal protocol OptionalProtocol {
	var isNil: Bool { get }
}

extension Optional : OptionalProtocol {
	var isNil: Bool { return self == nil }
}

internal func integer<Integer : BinaryInteger>(from value: Any, codingPath: [CodingKey]) throws -> Integer {
	
	let result: Integer?
	switch value {
		case let i as Int:		result = Integer(exactly: i)
		case let i as Int8:		result = Integer(exactly: i)
		case let i as Int16:	result = Integer(exactly: i)
		case let i as Int32:	result = Integer(exactly: i)
		case let i as Int64:	result = Integer(exactly: i)
		case let i as UInt:		result = Integer(exactly: i)
		case let i as UInt8:	result = Integer(exactly: i)
		case let i as UInt16:	result = Integer(exactly: i)
		case let i as UInt32:	result = Integer(exactly: i)
		case let i as UInt64:	result = Integer(exactly: i)
		case let other:			throw DecodingError.typeMismatch(Integer.self, .init(codingPath: codingPath, debugDescription: "Could not decode \(other) of type \(type(of: other)) as \(Integer.self)"))
	}
	
	guard let integer = result else { throw DecodingError.typeMismatch(Integer.self, .init(codingPath: codingPath, debugDescription: "Could not convert \(value) of type \(type(of: value)) to \(Integer.self)")) }
	return integer
	
}

internal func number<Number : BinaryFloatingPoint>(from value: Any, codingPath: [CodingKey]) throws -> Number {
	
	let result: Number?
	switch value {
		case let i as Float:	result = Number(exactly: i)
		case let i as Float64:	result = Number(exactly: i)
		case let i as Float80:	result = Number(exactly: i)
		case let i as Double:	result = Number(exactly: i)
		case let other:			throw DecodingError.typeMismatch(Number.self, .init(codingPath: codingPath, debugDescription: "Could not decode \(other) of type \(type(of: other)) as \(Number.self)"))
	}
	
	guard let number = result else { throw DecodingError.typeMismatch(Number.self, .init(codingPath: codingPath, debugDescription: "Could not convert \(value) of type \(type(of: value)) to \(Number.self)")) }
	return number
	
}
