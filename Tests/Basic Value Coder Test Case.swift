// DepthKit © 2017–2021 Constantino Tsarouhas

import XCTest
@testable import DepthKit

class BasicValueCoderTestCase : XCTestCase {
	
	let basicValue = Value(
		att1: "value",
		att2: 1,
		att3: .init(sub1: 1, sub2: [1, 2, 3], sub3: ["a", "b", "c"]),
		att4: nil,
		att5: ""
	)
	
	let differingValue = Value(
		att1: "value",
		att2: 1,
		att3: .init(sub1: 1, sub2: [1, 2, 3], sub3: ["a", "d", "c"]),
		att4: nil,
		att5: ""
	)
	
	struct Value : Decodable, Equatable {
		
		let att1: String
		let att2: Int
		let att3: S
		let att4: Int?
		let att5: String?
		
		struct S : Decodable, Equatable {
			let sub1: Int
			let sub2: [Int]
			let sub3: [String]
		}
		
	}
	
	func testBasic() throws {
		
		let dictionary: [String : Any] = [
			"att1" : "value",
			"att2" : 1,
			"att3" : ["sub1" : 1, "sub2" : [1, 2, 3], "sub3" : ["a", "b", "c"]],
			"att4" : Int?.none as Any,
			"att5" : "",
			"ignd" : "a"
		]
		
		let decodedValue = try BasicValueDecoder(value: dictionary).decode(Value.self)
		XCTAssertEqual(decodedValue, basicValue)
		XCTAssertNotEqual(decodedValue, differingValue)
		
	}
	
	func testMapped() throws {
		
		let dictionary: [String : Any] = [
			"key.att1" : "value",
			"key.att2" : 1,
			"key.att3" : ["key.sub1" : 1, "key.sub2" : [1, 2, 3], "key.sub3" : ["a", "b", "c"]],
			"key.att4" : Int?.none as Any,
			"key.att5" : "",
			"key.ignd" : "a"
		]
		
		let decoder = BasicValueDecoder(value: dictionary)
		decoder.convertedKeyValue = { "key.\($0)" }
		
		let decodedValue = try decoder.decode(Value.self)
		XCTAssertEqual(decodedValue, basicValue)
		XCTAssertNotEqual(decodedValue, differingValue)
		
	}
	
	func testConversions() throws {
		
		let dictionary: [String : Any] = [
			"att1" : "value",
			"att2" : 1 as UInt,
			"att3" : ["sub1" : 1 as Int64, "sub2" : [1, 2, 3], "sub3" : ["a", "b", "c"]],
			"att4" : Int16?.none as Any,
			"att5" : "",
			"ignd" : "a"
		]
		
		let decodedValue = try BasicValueDecoder(value: dictionary).decode(Value.self)
		XCTAssertEqual(decodedValue, basicValue)
		XCTAssertNotEqual(decodedValue, differingValue)
		
	}
	
	func testOverflow() throws {
		
		let dictionary: [String : Any] = [
			"att1" : "value",
			"att2" : UInt.max,
			"att3" : ["sub1" : 1 as Int64, "sub2" : [1, 2, 3], "sub3" : ["a", "b", "c"]],
			"att4" : Int16?.none as Any,
			"att5" : "",
			"ignd" : "a"
		]
		
		XCTAssertThrowsError(try BasicValueDecoder(value: dictionary).decode(Value.self), "Overflow not detected") { error in
			guard case DecodingError.typeMismatch(let type, _) = error else { return XCTFail("Wrong error thrown") }
			XCTAssertEqual(ObjectIdentifier(type), ObjectIdentifier(Int.self), "Wrong expected type")
		}
		
	}
	
}
