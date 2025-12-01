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
          .unsafeFlags([
            "-Xlinker", "-sectcreate",
            "-Xlinker", "__TEXT",
            "-Xlinker", "__info_plist",
            "-Xlinker", "Resources/Info.plist",
          ])
      ]
    ),
    .testTarget(
      name: "itunes-library-exportTests",
      dependencies: ["itunes-library-export"]
    ),
  ]
)
