// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "AsyncSequenceTestUtils",
  platforms: [
    .macOS(.v10_15),
    .iOS(.v13),
    .tvOS(.v13),
    .watchOS(.v6),
    .macCatalyst(.v16),
  ],
  products: [
    .library(
      name: "AsyncSequenceTestUtils",
      targets: ["AsyncSequenceTestUtils"]
    ),
  ],
  targets: [
    .target(
      name: "AsyncSequenceTestUtils"
    ),
    .testTarget(
      name: "AsyncSequenceTestUtilsTests",
      dependencies: ["AsyncSequenceTestUtils"]
    ),
  ]
)
