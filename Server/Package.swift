// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "Server",
    dependencies: [
        .Package(url: "https://github.com/uraimo/SwiftyGPIO.git", majorVersion: 0),
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 2)
    ]
)
