// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "composable-feedback-generator",
  platforms: [
    .iOS(.v13),
  ],
  products: [
    .library(
      name: "ComposableFeedbackGenerator",
      targets: ["ComposableFeedbackGenerator"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.8.0")
  ],
  targets: [
    .target(
      name: "ComposableFeedbackGenerator",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
    .testTarget(
      name: "ComposableFeedbackGeneratorTests",
      dependencies: ["ComposableFeedbackGenerator"]),
  ]
)
