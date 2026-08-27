// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Grassie",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "Grassie", targets: ["Grassie"])
    ],
    targets: [
        .executableTarget(
            name: "Grassie",
            path: "Sources/GrassTracker"
        )
    ]
)
