// DepthKit © 2017–2018 Constantino Tsarouhas

import XCTest
@testable import DepthKit

class ComparableCappingTestCase : XCTestCase {
	
	func testRange() {
		XCTAssertEqual(Int.min.capped(to: 5...10), 5)
		XCTAssertEqual((-1).capped(to: 5...10), 5)
		XCTAssertEqual(0.capped(to: 5...10), 5)
		XCTAssertEqual(1.capped(to: 5...10), 5)
		XCTAssertEqual(5.capped(to: 5...10), 5)
		XCTAssertEqual(9.capped(to: 5...10), 9)
		XCTAssertEqual(10.capped(to: 5...10), 10)
		XCTAssertEqual(11.capped(to: 5...10), 10)
		XCTAssertEqual(Int.max.capped(to: 5...10), 10)
	}
	
	func testRangeFrom() {
		XCTAssertEqual(Int.min.capped(to: 5...), 5)
		XCTAssertEqual((-5).capped(to: 5...), 5)
		XCTAssertEqual(0.capped(to: 5...), 5)
		XCTAssertEqual(5.capped(to: 5...), 5)
		XCTAssertEqual(10.capped(to: 5...), 10)
		XCTAssertEqual(Int.max.capped(to: 5...), .max)
	}
	
	func testRangeUpTo() {
		XCTAssertEqual(Int.min.capped(to: ...5), .min)
		XCTAssertEqual((-5).capped(to: ...5), -5)
		XCTAssertEqual(0.capped(to: ...5), 0)
		XCTAssertEqual(5.capped(to: ...5), 5)
		XCTAssertEqual(10.capped(to: ...5), 5)
		XCTAssertEqual(Int.max.capped(to: ...5), 5)
	}
	
	func testInterval() {
		XCTAssertEqual(1.capped(to: 5...10), 5, accuracy: 0.5)
		XCTAssertEqual(5.capped(to: 5...10), 5, accuracy: 0.5)
		XCTAssertEqual(10.capped(to: 5...10), 10, accuracy: 0.5)
		XCTAssertEqual(15.capped(to: 5...10), 10, accuracy: 0.5)
	}
	
	func testIntervalFrom() {
		XCTAssertEqual(1.capped(to: 5...), 5, accuracy: 0.5)
		XCTAssertEqual(5.capped(to: 5...), 5, accuracy: 0.5)
		XCTAssertEqual(10.capped(to: 5...), 10, accuracy: 0.5)
		XCTAssertEqual(15.capped(to: 5...), 15, accuracy: 0.5)
	}
	
	func testIntervalUpTo() {
		XCTAssertEqual(1.capped(to: ...10), 1, accuracy: 0.5)
		XCTAssertEqual(5.capped(to: ...10), 5, accuracy: 0.5)
		XCTAssertEqual(10.capped(to: ...10), 10, accuracy: 0.5)
		XCTAssertEqual(15.capped(to: ...10), 10, accuracy: 0.5)
	}
	
}
