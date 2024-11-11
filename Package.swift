// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JSwiftUI",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "JSwiftUI",
            targets: ["JSwiftUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/siteline/swiftui-introspect.git", from: "1.3.0")
    ],
    targets: [
        .target(
            name: "JSwiftUI",
            dependencies: [
                .product(name: "SwiftUIIntrospect", package: "swiftui-introspect")
            ]),
        .testTarget(
            name: "JSwiftUITests",
            dependencies: ["JSwiftUI"]),
    ]
)
