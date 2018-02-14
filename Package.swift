// swift-tools-version:3.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FileKit",
    dependencies: [
        .Package(url: "https://github.com/IBM-Swift/LoggerAPI.git", majorVersion: 1, minor: 7)
    ]
)
