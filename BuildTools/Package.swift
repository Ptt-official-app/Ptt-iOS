// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "BuildTools",
    platforms: [.iOS(.v14)],
    dependencies: [
         .package(url: "https://github.com/SwiftGen/SwiftGen", from: "6.0.0")
    ],
    targets: [.target(name: "BuildTools", path: "")]
)
