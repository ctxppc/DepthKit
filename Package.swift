// swift-tools-version:5.2
// DepthKit © 2017–2020 Constantino Tsarouhas

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
	swiftLanguageVersions: [.v4, .v5]
)
