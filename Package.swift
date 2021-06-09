// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "iTunesLibraryExport",
    platforms: [
        .macOS(.v10_13),
    ],
    targets: [
        .target(
            name: "itunes-library-export",
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
