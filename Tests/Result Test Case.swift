// DepthKit © 2017–2018 Constantino Tsarouhas

import XCTest
@testable import DepthKit

class ResultTestCase : XCTestCase {
	
	let yay = "yay"
	
	func alwaysSucceeds() throws -> String {
		return yay
	}
	
	func alwaysFails() throws -> String {
		throw SomeError.some
	}
	
	enum SomeError : Error {
		case some
	}
	
	func testInit() {
		guard case .error(SomeError.some) = Result(from: alwaysFails) else { return XCTFail() }
		guard case .value(let v) = Result(from: alwaysSucceeds), v == yay else { return XCTFail() }
	}
	
	func testValue() throws {
		XCTAssertEqual(try Result.value(yay).value(), yay)
		XCTAssertThrowsError(try Result<String>.error(SomeError.some).value()) { error in
			guard case SomeError.some = error else { return XCTFail() }
		}
	}
	
}
