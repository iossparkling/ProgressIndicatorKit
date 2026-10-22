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
            dependencies: [],
            resources: [
                // Bundles background.mp3 so `ProgressIndicatorAudio.defaultURL` can find it.
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "ProgressIndicatorKitTests",
            dependencies: ["ProgressIndicatorKit"]
        )
    ]
)
