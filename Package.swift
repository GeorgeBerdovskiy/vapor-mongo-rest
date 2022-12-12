// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "server",
    platforms: [
       .macOS(.v12)
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(url: "https://github.com/mongodb/mongo-swift-driver", .upToNextMajor(from: "1.3.1")),
        .package(url: "https://github.com/Kitura/Swift-JWT.git", from: "3.6.0")
    ],
    targets: [
        .target(
            name: "App",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "MongoSwift", package: "mongo-swift-driver"),
                .product(name: "MongoSwiftSync", package: "mongo-swift-driver"),
                .product(name: "SwiftJWT", package: "Swift-JWT")
            ],
            swiftSettings: [
                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
            ]
        ),
        .executableTarget(name: "Run", dependencies: [
            .target(name: "App"),
            .product(name: "MongoSwift", package: "mongo-swift-driver"),
            .product(name: "MongoSwiftSync", package: "mongo-swift-driver"),
            .product(name: "SwiftJWT", package: "Swift-JWT")
        ]),
        .testTarget(name: "AppTests", dependencies: [
            .target(name: "App"),
            .product(name: "XCTVapor", package: "vapor"),
        ])
    ]
)
