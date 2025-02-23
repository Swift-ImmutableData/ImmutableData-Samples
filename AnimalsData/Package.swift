// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "AnimalsData",
  platforms: [
    .macOS(.v14),
    .iOS(.v17),
    .tvOS(.v17),
    .watchOS(.v10),
    .macCatalyst(.v17),
  ],
  products: [
    .library(
      name: "AnimalsData",
      targets: ["AnimalsData"]
    ),
  ],
  dependencies: [
    .package(
      url: "https://github.com/apple/swift-algorithms.git",
      from: "1.2.0"
    ),
    .package(
      url: "https://github.com/apple/swift-async-algorithms.git",
      from: "1.0.3"
    ),
    .package(
      url: "https://github.com/vapor/vapor.git",
      from: "4.111.0"
    ),
    .package(path: "../AsyncSequenceTestUtils"),
    .package(path: "../ImmutableData"),
    .package(path: "../Services"),
  ],
  targets: [
    .target(
      name: "AnimalsData",
      dependencies: [
        "ImmutableData",
      ]
    ),
    .executableTarget(
      name: "AnimalsDataClient",
      dependencies: [
        "AnimalsData",
        "Services",
      ],
      linkerSettings: [
        .unsafeFlags([
          "-Xlinker", "-sectcreate",
          "-Xlinker", "__TEXT",
          "-Xlinker", "__info_plist",
          "-Xlinker", "Resources/AnimalsDataClient/Info.plist",
        ])
      ]
    ),
    .executableTarget(
      name: "AnimalsDataServer",
      dependencies: [
        .product(
          name: "AsyncAlgorithms",
          package: "swift-async-algorithms"
        ),
        .product(
          name: "Vapor",
          package: "vapor",
          condition: .when(platforms: [.macOS])
        ),
        "AnimalsData",
      ],
      linkerSettings: [
        .unsafeFlags([
          "-Xlinker", "-sectcreate",
          "-Xlinker", "__TEXT",
          "-Xlinker", "__info_plist",
          "-Xlinker", "Resources/AnimalsDataServer/Info.plist",
        ])
      ]
    ),
    .testTarget(
      name: "AnimalsDataTests",
      dependencies: [
        .product(
          name: "Algorithms",
          package: "swift-algorithms"
        ),
        "AnimalsData",
        "AsyncSequenceTestUtils",
      ]
    ),
  ]
)
