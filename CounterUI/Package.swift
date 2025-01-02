// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "CounterUI",
  platforms: [
    .macOS(.v14),
    .iOS(.v17),
    .tvOS(.v17),
    .watchOS(.v10),
    .macCatalyst(.v17),
  ],
  products: [
    .library(
      name: "CounterUI",
      targets: ["CounterUI"]
    ),
  ],
  dependencies: [
    .package(path: "../CounterData"),
    .package(path: "../ImmutableUI"),
  ],
  targets: [
    .target(
      name: "CounterUI",
      dependencies: [
        "CounterData",
        "ImmutableUI",
      ]
    ),
  ]
)
