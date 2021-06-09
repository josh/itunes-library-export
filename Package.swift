// swift-tools-version:5.4

import PackageDescription

let package = Package(
    name: "iTunesLibraryExport",
    platforms: [
        .macOS(.v10_13),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.4.0"),
    ],
    targets: [
        .executableTarget(
            name: "itunes-library-export",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            linkerSettings: [
                .linkedFramework("iTunesLibrary"),
            ]
        ),
        .testTarget(
            name: "itunes-library-exportTests",
            dependencies: ["itunes-library-export"]
        ),
    ]
)
