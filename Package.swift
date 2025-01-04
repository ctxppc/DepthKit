// swift-tools-version:6.0
// DepthKit © 2017–2025 Constantino Tsarouhas

import PackageDescription

let package = Package(
    name: "DepthKit",
	platforms: [.macOS(.v15), .iOS(.v18), .tvOS(.v18), .watchOS(.v11), .visionOS(.v2)],
	products: [
		.library(name: "DepthKit", targets: ["DepthKit"]),
	],
	dependencies: [
		.package(url: "https://github.com/apple/swift-algorithms.git", .upToNextMinor(from: "1.2.0")),
	],
	targets: [
		.target(name: "DepthKit", dependencies: [
			.product(name: "Algorithms", package: "swift-algorithms"),
		]),
		.testTarget(name: "DepthKitTests", dependencies: ["DepthKit"]),
	],
	swiftLanguageModes: [.v6]
)
