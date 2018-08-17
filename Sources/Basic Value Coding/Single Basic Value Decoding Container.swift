// DepthKit © 2017–2018 Constantino Tsarouhas

public struct SingleBasicValueDecodingContainer : SingleValueDecodingContainer {
	
	/// Creates a single basic value decoding container.
	internal init(value: Any, codingPath: [CodingKey]) {
		self.value = value
		self.codingPath = codingPath
	}
	
	/// The value to decode.
	private let value: Any
	
	// See protocol.
	public let codingPath: [CodingKey]
	
	// See protocol.
	public func decodeNil() -> Bool {
		guard let optional = value as? OptionalProtocol else { return false }
		return optional.isNil
	}
	
	// See protocol.
	public func decode(_ type: Bool.Type) throws -> Bool {
		return try decode()
	}
	
	// See protocol.
	public func decode(_ type: String.Type) throws -> String {
		return try decode()
	}
	
	// See protocol.
	public func decode(_ type: Double.Type) throws -> Double {
		return try decode()
	}
	
	// See protocol.
	public func decode(_ type: Float.Type) throws -> Float {
		return try decode()
	}
	
	// See protocol.
	public func decode(_ type: Int.Type) throws -> Int {
		return try decode()
	}
	
	// See protocol.
	public func decode(_ type: Int8.Type) throws -> Int8 {
		return try decode()
	}
	
	// See protocol.
	public func decode(_ type: Int16.Type) throws -> Int16 {
		return try decode()
	}
	
	// See protocol.
	public func decode(_ type: Int32.Type) throws -> Int32 {
		return try decode()
	}
	
	// See protocol.
	public func decode(_ type: Int64.Type) throws -> Int64 {
		return try decode()
	}
	
	// See protocol.
	public func decode(_ type: UInt.Type) throws -> UInt {
		return try decode()
	}
	
	// See protocol.
	public func decode(_ type: UInt8.Type) throws -> UInt8 {
		return try decode()
	}
	
	// See protocol.
	public func decode(_ type: UInt16.Type) throws -> UInt16 {
		return try decode()
	}
	
	// See protocol.
	public func decode(_ type: UInt32.Type) throws -> UInt32 {
		return try decode()
	}
	
	// See protocol.
	public func decode(_ type: UInt64.Type) throws -> UInt64 {
		return try decode()
	}
	
	private func decode<Integer : BinaryInteger & Decodable>() throws -> Integer {
		return try integer(from: value, codingPath: codingPath)
	}
	
	private func decode<Number : BinaryFloatingPoint & Decodable>() throws -> Number {
		return try number(from: value, codingPath: codingPath)
	}
	
	// See protocol.
	public func decode<T : Decodable>(_ type: T.Type) throws -> T {
		return try decode()
	}
	
	/// Decodes the value.
	public func decode<T>() throws -> T {
		guard let decodedValue = value as? T else { throw DecodingError.typeMismatch(T.self, .init(codingPath: codingPath, debugDescription: "Expected \(T.self); got \(value) of type \(type(of: value))")) }
		return decodedValue
	}
	
}
