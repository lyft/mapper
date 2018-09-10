// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "Mapper",
    products: [
        .library(name: "Mapper", targets: ["Mapper"]),
    ],
    targets: [
        .target(name: "Mapper", path: "Sources"),
        .testTarget(name: "MapperTests", dependencies: ["Mapper"]),
    ],
    swiftLanguageVersions: [.v4, .v4_2]
)
