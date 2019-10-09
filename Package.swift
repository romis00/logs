// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "app",
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0-alpha.2"),
        .package(url: "https://gitlab.nexustls.com/libraries/nats_utilities.git", .branch("NIO2")),
        .package(url: "https://gitlab.nexustls.com/libraries/nats-swift.git", .branch("Dev")),
    ],
    targets: [
        .target(name: "App", dependencies: ["Nats",  "NatsUtilities", "Vapor"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

