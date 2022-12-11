// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "server",
    platforms: [
       .macOS(.v12)
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(url: "https://github.com/mongodb/mongo-swift-driver", .upToNextMajor(from: "1.3.1"))
            ],
            targets: [
                .target(
                    name: "App",
                    dependencies: [
                        .product(name: "Vapor", package: "vapor"),
                        .product(name: "MongoSwift", package: "mongo-swift-driver"),
                        .product(name: "MongoSwiftSync", package: "mongo-swift-driver")
                    ],
                    swiftSettings: [
                        // Enable better optimizations when building in Release configuration. Despite the use of
                        // the `.unsafeFlags` construct required by SwiftPM, this flag is recommended for Release
                        // builds. See <https://github.com/swift-server/guides/blob/main/docs/building.md#building-for-production> for details.
                        .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
                    ]
                ),
                .executableTarget(name: "Run", dependencies: [.target(name: "App"),
                     .product(name: "MongoSwift", package: "mongo-swift-driver"),
                     .product(name: "MongoSwiftSync", package: "mongo-swift-driver")]),
                .testTarget(name: "AppTests", dependencies: [
                    .target(name: "App"),
                    .product(name: "XCTVapor", package: "vapor"),
                ])
            ]
        )
