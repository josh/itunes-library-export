// swift-tools-version:5.7

import PackageDescription

let package = Package(
  name: "iTunesLibraryExport",
  platforms: [
    .macOS(.v13)
  ],
  targets: [
    .executableTarget(
      name: "itunes-library-export",
      linkerSettings: [
        .linkedFramework("iTunesLibrary")
      ]
    ),
    .testTarget(
      name: "itunes-library-exportTests",
      dependencies: ["itunes-library-export"]
    ),
  ]
)
