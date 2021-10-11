// swift-tools-version:5.2

import PackageDescription

let package = Package(
  name: "nsdi",
  products: [
    .library(
      name: "NSDI",
      targets: ["NSDI"]
    ),
  ],
  dependencies: [],
  targets: [
    .target(
      name: "NSDI",
      dependencies: []
    ),
    .testTarget(
      name: "NSDITests",
      dependencies: ["NSDI"]
    ),
  ]
)
