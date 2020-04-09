// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "AppStoreKit",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(name: "AppStoreKit", targets: ["AppStoreKit"])
    ],
    dependencies: [
        // It's a good thing to keep things relatively
        // independent, but add any dependencies here.
    ],
    targets: [
        .target(
            name: "AppStoreKit",
            dependencies: [],
            swiftSettings: [
                .define("DEBUG", .when(configuration: .debug)),
                .define("RELEASE", .when(configuration: .release)),
                .define("SWIFT_PACKAGE")
            ]),
        .target(
            name: "appstore",
            dependencies: ["AppStoreKit"],
            swiftSettings: [
                .define("DEBUG", .when(configuration: .debug)),
                .define("RELEASE", .when(configuration: .release)),
                .define("SWIFT_PACKAGE")
            ]),
        .testTarget(name: "AppStoreKitTests", dependencies: ["AppStoreKit"]),
    ]
)
