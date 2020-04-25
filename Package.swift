// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "PureLayout",
    platforms: [.iOS(.v8), .macOS(.v10_10), .tvOS(.v9)],
    products: [
        .library(
            name: "PureLayout",
            targets: ["PureLayout"])
    ],
    targets: [
        .target(
            name: "PureLayout",
            path: "PureLayout/PureLayout",
            publicHeadersPath: ".")
    ]
)
