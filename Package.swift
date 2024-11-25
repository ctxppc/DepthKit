// swift-tools-version:6.0
// DepthKit © 2017–2024 Constantino Tsarouhas

import PackageDescription

let package = Package(
    name: "DepthKit",
	products: [
		.library(name: "DepthKit", targets: ["DepthKit"])
	],
	targets: [
		.target(name: "DepthKit", path: "Sources"),
		.testTarget(name: "DepthKitTests", dependencies: ["DepthKit"], path: "Tests")
	],
	swiftLanguageModes: [.v6]
)
