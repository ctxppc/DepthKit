// DepthKit © 2017–2020 Constantino Tsarouhas

public struct UnkeyedBasicValueDecodingContainer : UnkeyedDecodingContainer {
	
	/// Creates a decoding container with given backing array and coding path.
	internal init(for decoder: BasicValueDecoder, decoding array: [Any], at codingPath: [CodingKey]) {
		self.array = array
		self.decoder = decoder
		self.codingPath = codingPath
	}
	
	/// The backing array.
	private let array: [Any]
	
	/// The decoder that created the container.
	private let decoder: BasicValueDecoder
	
	// See protocol.
	public let codingPath: [CodingKey]
	
	// See protocol.
	public var count: Int? {
		return array.count
	}
	
	// See protocol.
	public var isAtEnd: Bool {
		return currentIndex >= array.endIndex
	}
	
	// See protocol.
	public var currentIndex: Int = 0
	
	// See protocol.
	public mutating func decodeNil() throws -> Bool {
		if (try peek(expectedType: Any.self) as? OptionalProtocol).isNil {
			currentIndex += 1
			return true
		} else {
			return false
		}
	}
	
	// See protocol.
	public mutating func decode(_ type: Bool.Type) throws -> Bool {
		return try decode()
	}
	
	// See protocol.
	public mutating func decode(_ type: String.Type) throws -> String {
		return try decode()
	}
	
	// See protocol.
	public mutating func decode(_ type: Double.Type) throws -> Double {
		return try decode()
	}
	
	// See protocol.
	public mutating func decode(_ type: Float.Type) throws -> Float {
		return try decode()
	}
	
	// See protocol.
	public mutating func decode(_ type: Int.Type) throws -> Int {
		return try decode()
	}
	
	// See protocol.
	public mutating func decode(_ type: Int8.Type) throws -> Int8 {
		return try decode()
	}
	
	// See protocol.
	public mutating func decode(_ type: Int16.Type) throws -> Int16 {
		return try decode()
	}
	
	// See protocol.
	public mutating func decode(_ type: Int32.Type) throws -> Int32 {
		return try decode()
	}
	
	// See protocol.
	public mutating func decode(_ type: Int64.Type) throws -> Int64 {
		return try decode()
	}
	
	// See protocol.
	public mutating func decode(_ type: UInt.Type) throws -> UInt {
		return try decode()
	}
	
	// See protocol.
	public mutating func decode(_ type: UInt8.Type) throws -> UInt8 {
		return try decode()
	}
	
	// See protocol.
	public mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
		return try decode()
	}
	
	// See protocol.
	public mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
		return try decode()
	}
	
	// See protocol.
	public mutating func decode(_ type: UInt64.Type) throws -> UInt64 {
		return try decode()
	}
	
	private mutating func decode<Integer : BinaryInteger & Decodable>() throws -> Integer {
		let rawValue = try peek(expectedType: Integer.self)
		let decodedValue: Integer = try integer(from: rawValue, codingPath: codingPath.appending(BasicValueCodingKey(index: currentIndex)))
		currentIndex += 1
		return decodedValue
	}
	
	private mutating func decode<Number : BinaryFloatingPoint & Decodable>() throws -> Number {
		let rawValue = try peek(expectedType: Number.self)
		let decodedValue: Number = try number(from: rawValue, codingPath: codingPath.appending(BasicValueCodingKey(index: currentIndex)))
		currentIndex += 1
		return decodedValue
	}
	
	// See protocol.
	public mutating func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
		return try decode()
	}
	
	public mutating func decode<T : Decodable>() throws -> T {
		let rawValue = try peek(expectedType: T.self)
		let decodedValue = try T(from: BasicValueDecoder(from: decoder, key: BasicValueCodingKey(index: currentIndex), value: rawValue))
		currentIndex += 1
		return decodedValue
	}
	
	// See protocol.
	public mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
		let rawValue = try peek(expectedType: [String : Any].self)
		let container = try BasicValueDecoder(from: decoder, key: BasicValueCodingKey(index: currentIndex), value: rawValue).container(keyedBy: type)
		currentIndex += 1
		return container
	}
	
	// See protocol.
	public mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
		let rawValue = try peek(expectedType: [Any].self)
		let container = try BasicValueDecoder(from: decoder, key: BasicValueCodingKey(index: currentIndex), value: rawValue).unkeyedContainer()
		currentIndex += 1
		return container
	}
	
	// See protocol.
	public mutating func superDecoder() throws -> Decoder {
		let rawValue = try peek(expectedType: [Any].self)
		currentIndex += 1
		return BasicValueDecoder(from: decoder, key: BasicValueCodingKey(index: currentIndex), value: rawValue)
	}
	
	/// Returns the next value without incrementing the index.
	///
	/// - Parameter expectedType: The expected type, for debugging purposes. The returned value might be of a different type.
	///
	/// - Throws: `DecodingError.valueNotFound` if `self.isAtEnd`.
	///
	/// - Returns: The next value.
	private func peek<T>(expectedType: T.Type) throws -> Any {
		guard !isAtEnd else { throw DecodingError.valueNotFound(expectedType, .init(codingPath: codingPath.appending(BasicValueCodingKey(index: currentIndex)), debugDescription: "No more values to decode in this container")) }
		return array[currentIndex]
	}
	
}
