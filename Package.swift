// swift-tools-version: 5.9
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
    dependencies: [
        .package(url: "https://github.com/nathanborror/swift-json", branch: "main"),
        .package(url: "https://github.com/apple/swift-argument-parser", branch: "main"),
    ],
    targets: [
        .target(name: "OpenAI", dependencies: [
            .product(name: "JSON", package: "swift-json"),
        ]),
        .executableTarget(name: "OpenAICmd", dependencies: [
            "OpenAI",
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
        ]),
    ]
)
