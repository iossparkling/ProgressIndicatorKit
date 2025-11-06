// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "ProgressIndicatorKit",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "ProgressIndicatorKit", targets: ["ProgressIndicatorKit"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ProgressIndicatorKit",
            dependencies: []
        ),
        .testTarget(
            name: "ProgressIndicatorKitTests",
            dependencies: ["ProgressIndicatorKit"]
        )
    ]
)
