// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "Mapper",
    products: [
        .library(name: "Mapper", targets: ["Mapper"]),
    ],
    targets: [
        .target(name: "Mapper", path: "Sources"),
        .testTarget(name: "MapperTests", dependencies: ["Mapper"]),
    ]
)
