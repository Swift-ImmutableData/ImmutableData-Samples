// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "ImmutableUI",
  platforms: [
    .macOS(.v14),
    .iOS(.v17),
    .tvOS(.v17),
    .watchOS(.v10),
    .macCatalyst(.v17),
  ],
  products: [
    .library(
      name: "ImmutableUI",
      targets: ["ImmutableUI"]
    ),
  ],
  dependencies: [
    .package(path: "../AsyncSequenceTestUtils"),
    .package(path: "../ImmutableData"),
  ],
  targets: [
    .target(
      name: "ImmutableUI",
      dependencies: ["ImmutableData"]
    ),
    .testTarget(
      name: "ImmutableUITests",
      dependencies: [
        "AsyncSequenceTestUtils",
        "ImmutableUI",
      ]
    ),
  ]
)
