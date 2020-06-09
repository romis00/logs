// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "app",
    platforms: [
       .macOS(.v10_15)
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0-rc"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0-rc"),
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.0.0-rc"),
        .package(name: "nats-utilities", url: "https://gitlab.nexustls.com/libraries/nats_utilities.git", .branch("4.0.0")),
        .package(url: "https://gitlab.nexustls.com/libraries/nats-swift.git", from: "4.1.2"),
    ],
    targets: [
        .target(
            name: "App",
            dependencies:[
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
                .product(name: "NatsUtilities", package: "nats-utilities"),
            ]
        ),
        .target(name: "Run", dependencies: [.target(name: "App")]),
        .testTarget(name: "AppTests", dependencies: [
            .target(name: "App"),
            //.product(name: "XCTVapor", package: "vapor"),
        ])
    ]
)

