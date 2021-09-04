// swift-tools-version:5.4
// DepthKit © 2017–2021 Constantino Tsarouhas

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
	swiftLanguageVersions: [.v5]
)
