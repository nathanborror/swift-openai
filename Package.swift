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
        .executable(name: "OpenAICmd", targets: ["OpenAICmd"]),
    ],
    dependencies: [
        .package(url: "https://github.com/nathanborror/swift-shared-kit", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", branch: "main"),
    ],
    targets: [
        .target(name: "OpenAI", dependencies: [
            .product(name: "SharedKit", package: "swift-shared-kit"),
        ]),
        .executableTarget(name: "OpenAICmd", dependencies: [
            "OpenAI",
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
        ]),
        .testTarget(name: "OpenAITests", dependencies: ["OpenAI"]),
    ]
)
