// DepthKit © 2017–2020 Constantino Tsarouhas

import XCTest
@testable import DepthKit

class ConditionalTestCase : XCTestCase {
	
	func testEffectConditional() {
		
		var integer = 0
		
		var increment = false
		increment --> (integer += 1)
		XCTAssertEqual(integer, 0)
		
		increment = true
		increment --> (integer += 1)
		XCTAssertEqual(integer, 1)
		
	}
	
	func testMaterialConditional() {
		
		func notEvaluated() -> Bool {
			XCTFail("Consequent evaluated when antecedent is false")
			return false
		}
		
		XCTAssertEqual(false --> notEvaluated(), true)
		XCTAssertEqual(true --> false, false)
		XCTAssertEqual(true --> true, true)
		
	}
	
}
