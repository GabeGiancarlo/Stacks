// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Intitled",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Intitled",
            targets: ["Intitled"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "10.18.0"),
        .package(url: "https://github.com/nalexn/ViewInspector", from: "0.9.7"),
    ],
    targets: [
        .target(
            name: "Intitled",
            dependencies: [
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseStorage", package: "firebase-ios-sdk"),
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "IntitledTests",
            dependencies: [
                "Intitled",
                .product(name: "ViewInspector", package: "ViewInspector"),
            ],
            path: "Tests"
        ),
    ]
) 