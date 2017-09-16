// swift-tools-version:4.0
// DepthKit © 2017 Constantino Tsarouhas

import PackageDescription

let package = Package(
    name: "DepthKit",
	products: [
		.library(name: "DepthKit", targets: ["DepthKit"])
	],
	targets: [
		.target(name: "DepthKit", path: "Sources"),
		.testTarget(name: "DepthKit Tests", dependencies: ["DepthKit"], path: "Tests")
	]
)
