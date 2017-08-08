// swift-tools-version:4.0

import PackageDescription

#if swift(>=4.0)

let package = Package(
  name: "Shuffle",
  products: [ .library(name: "Shuffle", type: .static, targets: ["Shuffle"]) ],
  targets: [
    .target(name: "Shuffle", path: "Sources"),
    .testTarget(name: "ShuffleTests", dependencies: ["Shuffle"])
  ],
  swiftLanguageVersions: [3,4]
)

#else

let package = Package(
	name: "Shuffle"
)

#endif
