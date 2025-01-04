// DepthKit © 2017–2025 Constantino Tsarouhas

import XCTest
@testable import DepthKit

class CollectionPaddingTestCase : XCTestCase {
	
	func testLeadingPaddingArray() {
		
		let original = [1, 2, 3, 4]
		
		let unpadded = original.padded(at: original.startIndex, withContentsOf: [0, 0], toCount: 4)
		XCTAssert(unpadded == original)
		
		let singleUnpadded = original.padded(at: original.startIndex, with: 0, toCount: 4)
		XCTAssert(singleUnpadded == original)
		
		let evenPadded = original.padded(at: original.startIndex, withContentsOf: [0, 0], toCount: 10)
		XCTAssert(evenPadded == [0, 0, 0, 0, 0, 0, 1, 2, 3, 4])
		
		let unevenPadded = original.padded(at: original.startIndex, withContentsOf: [0, 0], toCount: 11)
		XCTAssert(unevenPadded == [0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4])
		
		let singlePadded = original.padded(at: original.startIndex, with: 0, toCount: 11)
		XCTAssert(singlePadded == [0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4])
		
	}
	
	func testMiddlePaddingArray() {
		
		let original = [1, 2, 3, 4]
		
		let unpadded = original.padded(at: 1, withContentsOf: [0, 0], toCount: 4)
		XCTAssert(unpadded == original)
		
		let singleUnpadded = original.padded(at: 1, with: 0, toCount: 4)
		XCTAssert(singleUnpadded == original)
		
		let evenPadded = original.padded(at: 1, withContentsOf: [0, 0], toCount: 10)
		XCTAssert(evenPadded == [1, 0, 0, 0, 0, 0, 0, 2, 3, 4])
		
		let unevenPadded = original.padded(at: 1, withContentsOf: [0, 0], toCount: 11)
		XCTAssert(unevenPadded == [1, 0, 0, 0, 0, 0, 0, 0, 0, 2, 3, 4])
		
		let singlePadded = original.padded(at: 1, with: 0, toCount: 10)
		XCTAssert(singlePadded == [1, 0, 0, 0, 0, 0, 0, 2, 3, 4])
		
	}
	
	func testTrailingPaddingArray() {
		
		let original = [1, 2, 3, 4]
		
		let unpadded = original.padded(at: original.endIndex, withContentsOf: [0, 0], toCount: 4)
		XCTAssert(unpadded == original)
		
		let singleUnpadded = original.padded(at: original.endIndex, with: 0, toCount: 4)
		XCTAssert(singleUnpadded == original)
		
		let evenPadded = original.padded(at: original.endIndex, withContentsOf: [0, 0], toCount: 10)
		XCTAssert(evenPadded == [1, 2, 3, 4, 0, 0, 0, 0, 0, 0])
		
		let unevenPadded = original.padded(at: original.endIndex, withContentsOf: [0, 0], toCount: 11)
		XCTAssert(unevenPadded == [1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 0])
		
		let singlePadded = original.padded(at: original.endIndex, with: 0, toCount: 10)
		XCTAssert(singlePadded == [1, 2, 3, 4, 0, 0, 0, 0, 0, 0])
		
	}
	
	func testPaddingEmptyArray() {
		
		let unpadded = [].padded(at: 0, withContentsOf: [1, 1, 1], toCount: 0)
		XCTAssert(unpadded == [])
		
		let singleUnpadded = [].padded(at: 0, with: 1, toCount: 0)
		XCTAssert(singleUnpadded == [])
		
		let evenPadded = [].padded(at: 0, withContentsOf: [1, 1, 1], toCount: 6)
		XCTAssert(evenPadded == [1, 1, 1, 1, 1, 1])
		
		let unevenPadded = [].padded(at: 0, withContentsOf: [1, 1, 1], toCount: 5)
		XCTAssert(unevenPadded == [1, 1, 1, 1, 1, 1])
		
		let singlePadded = [].padded(at: 0, with: 1, toCount: 6)
		XCTAssert(singlePadded == [1, 1, 1, 1, 1, 1])
		
	}
	
	func testLeadingPaddingString() {
		
		let original = "My unit tests pass! 😂"		// 21 characters
		
		let unpadded = original.padded(at: original.startIndex, withContentsOf: "🚨🚨", toCount: 21)
		XCTAssert(unpadded == original)
		
		let evenPadded = original.padded(at: original.startIndex, withContentsOf: "🚨🚨", toCount: 25)
		XCTAssert(evenPadded == "🚨🚨🚨🚨My unit tests pass! 😂")
		
		let unevenPadded = original.padded(at: original.startIndex, withContentsOf: "🚨🚨", toCount: 22)
		XCTAssert(unevenPadded == "🚨🚨My unit tests pass! 😂")
		
		let singleUnpadded = original.padded(at: original.startIndex, with: "🚨", toCount: 21)
		XCTAssert(singleUnpadded == original)
		
		let singlePadded = original.padded(at: original.startIndex, with: "🚨", toCount: 25)
		XCTAssert(singlePadded == "🚨🚨🚨🚨My unit tests pass! 😂")
		
	}
	
	func testMiddlePaddingString() {
		
		let original = "My unit tests pass! 😂"		// 21 characters
		
		let unpadded = original.padded(at: original.firstIndex(of: "u")!, withContentsOf: "uu", toCount: 21)
		XCTAssert(unpadded == original)
		
		let evenPadded = original.padded(at: original.firstIndex(of: "u")!, withContentsOf: "uu", toCount: 25)
		XCTAssert(evenPadded == "My uuuuunit tests pass! 😂")
		
		let unevenPadded = original.padded(at: original.firstIndex(of: "u")!, withContentsOf: "uu", toCount: 22)
		XCTAssert(unevenPadded == "My uuunit tests pass! 😂")
		
		let singleUnpadded = original.padded(at: original.firstIndex(of: "u")!, with: "u", toCount: 21)
		XCTAssert(singleUnpadded == original)
		
		let singlePadded = original.padded(at: original.firstIndex(of: "u")!, with: "u", toCount: 25)
		XCTAssert(singlePadded == "My uuuuunit tests pass! 😂")
		
	}
	
	func testTrailingPaddingString() {
		
		let original = "My unit tests pass! 😂"		// 21 characters
		
		let unpadded = original.padded(at: original.endIndex, withContentsOf: "😅😂", toCount: 21)
		XCTAssert(unpadded == original)
		
		let evenPadded = original.padded(at: original.endIndex, withContentsOf: "😅😂", toCount: 25)
		XCTAssert(evenPadded == "My unit tests pass! 😂😅😂😅😂")
		
		let unevenPadded = original.padded(at: original.endIndex, withContentsOf: "😅😂", toCount: 22)
		XCTAssert(unevenPadded == "My unit tests pass! 😂😅😂")
		
		let singleUnpadded = original.padded(at: original.endIndex, with: "😂", toCount: 21)
		XCTAssert(singleUnpadded == original)
		
		let singlePadded = original.padded(at: original.endIndex, with: "😂", toCount: 25)
		XCTAssert(singlePadded == "My unit tests pass! 😂😂😂😂😂")
		
	}
	
}
