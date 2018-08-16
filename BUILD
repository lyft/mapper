load(
    "@build_bazel_rules_apple//apple:macos.bzl",
    "macos_unit_test",
)

load(
    "@build_bazel_rules_apple//apple:ios.bzl",
    "ios_unit_test",
)

load(
    "@build_bazel_rules_swift//swift:swift.bzl",
    "swift_library",
)

swift_library(
  name = "Mapper",
  srcs = glob(["Sources/*.swift"]),
)

swift_library(
  name = "MapperTestsBinary",
  srcs = glob(["Tests/MapperTests/*.swift"]),
  deps = [":Mapper"],
)

ios_unit_test(
  name = "MapperiOSTests",
  deps = [":MapperTestsBinary"],
  minimum_os_version = "8.0",
)

macos_unit_test(
  name = "MappermacOSTests",
  deps = [":MapperTestsBinary"],
  minimum_os_version = "10.10",
)
