// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Swiftux",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "Swiftux",
            targets: ["Swiftux"]),
    ],
    targets: [
        .target(
            name: "Swiftux",
            dependencies: []),
        .testTarget(
            name: "SwiftuxTests",
            dependencies: ["Swiftux"]),
    ]
)
