// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-openai",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .watchOS(.v9),
        .tvOS(.v16),
    ],
    products: [
        .library(name: "OpenAI", targets: ["OpenAI"]),
    ],
    targets: [
        .target(name: "OpenAI", dependencies: []),
        .testTarget(name: "OpenAITests", dependencies: ["OpenAI"]),
    ]
)
