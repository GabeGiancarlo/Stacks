// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Intitled",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "Intitled", targets: ["IntitledApp"])
    ],
    dependencies: [],
    targets: [
        // App target
        .target(
            name: "IntitledApp",
            dependencies: [
                "LibraryFeature",
                "ScannerFeature", 
                "DiscoverFeature",
                "ProfileFeature",
                "ShopFeature",
                "DataLayer",
                "ServicesLayer",
                "Resources"
            ]
        ),
        
        // Feature modules
        .target(
            name: "LibraryFeature",
            dependencies: ["DataLayer", "Resources"]
        ),
        .target(
            name: "ScannerFeature",
            dependencies: ["ServicesLayer", "DataLayer"]
        ),
        .target(
            name: "DiscoverFeature",
            dependencies: ["DataLayer"]
        ),
        .target(
            name: "ProfileFeature",
            dependencies: ["DataLayer", "Resources"]
        ),
        .target(
            name: "ShopFeature",
            dependencies: ["ServicesLayer"]
        ),
        
        // System layers
        .target(name: "DataLayer"),
        .target(
            name: "ServicesLayer",
            dependencies: ["Resources"]
        ),
        .target(
            name: "Resources",
            resources: [.process("Assets")]
        ),
        
        // Tests
        .testTarget(
            name: "IntitledTests",
            dependencies: ["IntitledApp"]
        )
    ]
) 