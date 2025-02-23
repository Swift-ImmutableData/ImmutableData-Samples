// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "ImmutableData",
  platforms: [
    .macOS(.v10_15),
    .iOS(.v13),
    .tvOS(.v13),
    .watchOS(.v6),
    .macCatalyst(.v13),
  ],
  products: [
    .library(
      name: "ImmutableData",
      targets: ["ImmutableData"]
    ),
  ],
  targets: [
    .target(
      name: "ImmutableData"
    ),
    .testTarget(
      name: "ImmutableDataTests",
      dependencies: ["ImmutableData"]
    ),
  ]
)
