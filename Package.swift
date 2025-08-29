// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Y_SwiftUIToast",
    platforms: [
        .iOS(.v14),
        .macOS(.v12)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Y_SwiftUIToast",
            targets: ["Y_SwiftUIToast"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Y_SwiftUIToast"),
        .testTarget(
            name: "Y_SwiftUIToastTests",
            dependencies: ["Y_SwiftUIToast"]
        ),
    ]
)
