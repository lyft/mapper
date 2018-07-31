# master

## Breaking

- None

## Enhancements

- None

# 8.1.0

## Breaking

- None

## Enhancements

- Fix `Float` behavior for some values
  [Keith Smiley](https://github.com/keith)
  [#142](https://github.com/lyft/mapper/pull/142)

# 8.0.0

## Breaking

- Update for Swift 4.1 and `compactMap`
  [Keith Smiley](https://github.com/keith)
  [#136](https://github.com/lyft/mapper/pull/136)

## Enhancements

- None

# 7.4.1

## Breaking

- None

## Enhancements

- Updated watchOS and macOS deployment target in xcodeproj to match these from podspec
  [Łukasz Mróz](https://github.com/sunshinejr)
  [#134](https://github.com/lyft/mapper/pull/134)

# 7.4.0

## Breaking

- None

## Enhancements

- Support `from` Array of Fields for Custom Transformation
  [Brett Jones](https://github.com/brodney)
  [#131](https://github.com/lyft/mapper/pull/131)

## Bug Fixes

- Fix the App Store submission issue with Carthage and coverage data described [here](https://github.com/Carthage/Carthage/issues/2056).

# 7.3.0

## Breaking

- None

## Enhancements

- Add `optionalFrom` for arrays of `RawRepresentable`s
  [Keith Smiley](https://github.com/keith)
  [#125](https://github.com/lyft/mapper/pull/125)
- Support non-optional mapping from list of fields
  [Michael Rebello](https://github.com/rebello95)
  [#126](https://github.com/lyft/mapper/pull/126)

# 7.2.0

## Breaking

- None

## Enhancements

- Support Array Of Fields For Custom Transformation
  [Daniel Duan](https://github.com/dduan)
  [#120](https://github.com/lyft/mapper/pull/120)

# 7.1.0

## Breaking

- None

## Enhancements

- Remove call to characters on string
  [Keith Smiley](https://github.com/keith)
  [#116](https://github.com/lyft/mapper/pull/116)
- Add Convertible implementations for `U?Int(32|64)`
  [Daniel Duan](https://github.com/dduan)
  [#117](https://github.com/lyft/mapper/pull/117)

# 7.0.0

## Breaking

- Update for Swift 4
  [Keith Smiley](https://github.com/keith)
  [#113](https://github.com/lyft/mapper/pull/113)

## Enhancements

- Add `@nonobjc` to our `NSDictionary` extension
  [Keith Smiley](https://github.com/keith)
  [#107](https://github.com/lyft/mapper/pull/107)

## Bug Fixes

- None

# 6.0.0

## Breaking

- Fix Xcode 8.1 `Any` -> `Any?` warning
  [Keith Smiley](https://github.com/keith)
  [#87](https://github.com/lyft/mapper/pull/87)

## Enhancements

- Add JSONSerialization integration tests
  [Keith Smiley](https://github.com/keith)
  [#90](https://github.com/lyft/mapper/pull/90)
- Test with optimizations
  [Keith Smiley](https://github.com/keith)
  [#92](https://github.com/lyft/mapper/pull/92)
- Strip down xcodeproj settings
  [Keith Smiley](https://github.com/keith)
  [#91](https://github.com/lyft/mapper/pull/91)

## Bug Fixes

- Fix `TimeInterval` test
  [Keith Smiley](https://github.com/keith)
  [#88](https://github.com/lyft/mapper/pull/88)

# 5.0.0

## Breaking

- Swift 3.0 support
  [Keith Smiley](https://github.com/keith)
  [#76](https://github.com/lyft/mapper/pull/76)
- Update transformation function to take `Any`
  [Keith Smiley](https://github.com/keith)
  [#76](https://github.com/lyft/mapper/pull/76)

## Enhancements

- Remove duplicate `Hashable` protocol conformance
  [Keith Smiley](https://github.com/keith)
  [#108](https://github.com/lyft/mapper/pull/108)

## Bug Fixes

- None

# 4.0.0

## Breaking

- Swift 2.3 support
  [Keith Smiley](https://github.com/keith)
  [#73](https://github.com/lyft/mapper/pull/73)

## Enhancements

- None

## Bug Fixes

- None

# 3.0.0

## Breaking

- Require types to be `Convertible` in order to use them.
  [Keith Smiley](https://github.com/keith)
  [#59](https://github.com/lyft/mapper/pull/59)
- Allow transformations to throw when the field is missing
  [Keith Smiley](https://github.com/keith)
  [#52](https://github.com/lyft/mapper/pull/52)
- Remove the `MapperError` initializer
  [Keith Smiley](https://github.com/keith)
  [#53](https://github.com/lyft/mapper/pull/53)

## Enhancements

- Add `@noescape` to transformation closures
  [Keith Smiley](https://github.com/keith)
  [#60](https://github.com/lyft/mapper/pull/60)
- Add `from` for arrays of `RawRepresentable`s
  [Keith Smiley](https://github.com/keith)
  [#61](https://github.com/lyft/mapper/pull/61)
- Remove force trys and casts from tests
  [Keith Smiley](https://github.com/keith)
  [#62](https://github.com/lyft/mapper/pull/62)

## Bug Fixes

- Fix `valueForKeyPath` crash by removing it.
  [Keith Smiley](https://github.com/keith)
  [#63](https://github.com/lyft/mapper/pull/63)

# 2.1.0

## Breaking

- None

## Enhancements

- Add custom `MapperError`s
  [Keith Smiley](https://github.com/keith)
  [#48](https://github.com/lyft/mapper/pull/48)

## Bug Fixes

- None

# 2.0.1

## Breaking

- None

## Enhancements

- None

## Bug Fixes

- Remove `try?` workaround which was fixed with Swift 2.2.1
  [Keith Smiley](https://github.com/keith)
  [#47](https://github.com/lyft/mapper/pull/47)

# 2.0.0

## Breaking

- None

## Enhancements

- Update for Swift 2.2
  [Keith Smiley](https://github.com/keith)
  [#41](https://github.com/lyft/mapper/pull/41)

## Bug Fixes

- None

# 1.0.4

## Breaking

- None

## Enhancements

- None

## Bug Fixes

- Fix `try?` memory leak by removing uses of it
  [Keith Smiley](https://github.com/keith)
  [#39](https://github.com/lyft/mapper/pull/39)

# 1.0.3

## Breaking

- None

## Enhancements

- Add function for creating `Mappable`s from a `NSArray`
  [Keith Smiley](https://github.com/keith)
  [#27](https://github.com/lyft/mapper/pull/27)

## Bug Fixes

- Use extension safe API to fix warning
  [Keith Smiley](https://github.com/keith)
  [#29](https://github.com/lyft/mapper/pull/29)

# 1.0.2

## Breaking

- None

## Enhancements

- Added `@warn_unused_result` to functions declarations.
  [Ostap Taran](https://github.com/Austinate)
  [#19](https://github.com/lyft/mapper/pull/19)
- Add tvOS support. [Ostap Taran](https://github.com/Austinate)
  [#12](https://github.com/lyft/mapper/pull/12)
- Add universal framework support. This also adds watchOS support.
  [Keith Smiley](https://github.com/keith)
  [#20](https://github.com/lyft/mapper/pull/20)
- Add Swift package manager support
  [Keith Smiley](https://github.com/keith)
  [#22](https://github.com/lyft/mapper/pull/22)

## Bug Fixes

- Fix OS X framework bundle identifier
  [Keith Smiley](https://github.com/keith)

# 1.0.1

## Breaking

- None

## Enhancements

- None

## Bug Fixes

- Fixed issue where `optionalFrom` with an array of keys was not
  implemented for `Convertible` or other types.
  [Keith Smiley](https://github.com/keith)
  [#10](https://github.com/lyft/mapper/pull/10)

# 1.0.0

Ship 1.0.0!
