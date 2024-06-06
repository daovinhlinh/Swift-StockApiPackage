// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "StocksAPI", // package name
    platforms: [ // support platforms
        .iOS(.v13),
        .macOS(.v12),
        .macCatalyst(.v13),
    ],
    products: [ // products that package produces, which can use by other packages
        .library( // library product, contain module can be imported by other Swift code
            name: "StocksAPI", // library name
            targets: ["StocksAPI"]),
        .executable(name: "StocksAPIExec", // Program can be run by OS
                    targets: ["StocksAPIExec"]),
    ],
    targets: [
        .target(
            name: "StocksAPI"),
        .executableTarget(name: "StocksAPIExec", dependencies: ["StocksAPI"]), // StockAPIExec depends on StockAPI library
        .testTarget(
            name: "StocksAPITests",
            dependencies: ["StocksAPI"]),
    ])
