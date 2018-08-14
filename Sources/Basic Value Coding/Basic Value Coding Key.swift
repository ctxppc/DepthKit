// DepthKit © 2017–2018 Constantino Tsarouhas

internal struct BasicValueCodingKey : CodingKey {
	
	// See protocol.
	public let stringValue: String
	
	// See protocol.
	public let intValue: Int?
	
	// See protocol.
	public init(stringValue: String) {
		self.stringValue = stringValue
		self.intValue = nil
	}
	
	// See protocol.
	public init(intValue: Int) {
		self.stringValue = "\(intValue)"
		self.intValue = intValue
	}
	
	public init(stringValue: String, intValue: Int?) {
		self.stringValue = stringValue
		self.intValue = intValue
	}
	
	internal init(index: Int) {
		self.stringValue = "Index \(index)"
		self.intValue = index
	}
	
	internal static let `super` = BasicValueCodingKey(stringValue: "super")
	
}
