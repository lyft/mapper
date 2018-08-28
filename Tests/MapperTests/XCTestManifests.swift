import XCTest

extension ConvertibleValueTests {
    static let __allTests = [
        ("testArrayOfConvertibles", testArrayOfConvertibles),
        ("testConvertibleArrayOfKeys", testConvertibleArrayOfKeys),
        ("testConvertibleArrayOfKeysDoesNotThrow", testConvertibleArrayOfKeysDoesNotThrow),
        ("testConvertibleArrayOfKeysReturnsNil", testConvertibleArrayOfKeysReturnsNil),
        ("testConvertibleArrayOfKeysThrowsWhenMissing", testConvertibleArrayOfKeysThrowsWhenMissing),
        ("testConvertingFloat", testConvertingFloat),
        ("testConvertingNonFloat", testConvertingNonFloat),
        ("testCreatingURL", testCreatingURL),
        ("testDictionaryButInvalidJSON", testDictionaryButInvalidJSON),
        ("testDictionaryConvertible", testDictionaryConvertible),
        ("testDictionaryConvertibleSingleInvalid", testDictionaryConvertibleSingleInvalid),
        ("testDictionaryOfConvertibles", testDictionaryOfConvertibles),
        ("testExistingOptionalArrayOfConvertibles", testExistingOptionalArrayOfConvertibles),
        ("testFloatDirectly", testFloatDirectly),
        ("testInvalidArrayOfConvertibles", testInvalidArrayOfConvertibles),
        ("testInvalidArrayOfOptionalConvertibles", testInvalidArrayOfOptionalConvertibles),
        ("testInvalidURL", testInvalidURL),
        ("testOptionalArrayOfConvertibles", testOptionalArrayOfConvertibles),
        ("testOptionalDictionaryConvertible", testOptionalDictionaryConvertible),
        ("testOptionalDictionaryConvertibleNil", testOptionalDictionaryConvertibleNil),
        ("testOptionalURL", testOptionalURL),
    ]
}

extension CustomTransformationTests {
    static let __allTests = [
        ("testCustomTransformation", testCustomTransformation),
        ("testCustomTransformationArrayOfKeys", testCustomTransformationArrayOfKeys),
        ("testCustomTransformationArrayOfKeysThrows", testCustomTransformationArrayOfKeysThrows),
        ("testCustomTransformationThrows", testCustomTransformationThrows),
        ("testOptionalCustomTransformationArrayOfKeys", testOptionalCustomTransformationArrayOfKeys),
        ("testOptionalCustomTransformationArrayOfKeysFails", testOptionalCustomTransformationArrayOfKeysFails),
        ("testOptionalCustomTransformationArrayOfKeysReturnsNil", testOptionalCustomTransformationArrayOfKeysReturnsNil),
        ("testOptionalCustomTransformationDoesNotExist", testOptionalCustomTransformationDoesNotExist),
        ("testOptionalCustomTransformationEmptyThrows", testOptionalCustomTransformationEmptyThrows),
        ("testOptionalCustomTransformationExists", testOptionalCustomTransformationExists),
        ("testOptionalCustomTransformationThrows", testOptionalCustomTransformationThrows),
    ]
}

extension ErrorTests {
    static let __allTests = [
        ("testConvertibleError", testConvertibleError),
        ("testCustomError", testCustomError),
        ("testInvalidRawValue", testInvalidRawValue),
        ("testMissingField", testMissingField),
        ("testTypeMismatch", testTypeMismatch),
    ]
}

extension InitializerTests {
    static let __allTests = [
        ("testCreatingFromArrayOfJSON", testCreatingFromArrayOfJSON),
        ("testCreatingFromInvalidArray", testCreatingFromInvalidArray),
        ("testCreatingFromPartiallyInvalidArrayOfJSON", testCreatingFromPartiallyInvalidArrayOfJSON),
        ("testCreatingInvalidFromJSON", testCreatingInvalidFromJSON),
        ("testCreatingValidFromJSON", testCreatingValidFromJSON),
        ("testCreatingWithConformanceInExtension", testCreatingWithConformanceInExtension),
    ]
}

extension JSONSerializationIntegrationTests {
    static let __allTests = [
        ("testDecodingDoubleFromJSON", testDecodingDoubleFromJSON),
        ("testDecodingNormalJSON", testDecodingNormalJSON),
    ]
}

extension MappableValueTests {
    static let __allTests = [
        ("testArrayOfMappables", testArrayOfMappables),
        ("testInvalidArrayOfMappables", testInvalidArrayOfMappables),
        ("testInvalidArrayOfOptionalMappables", testInvalidArrayOfOptionalMappables),
        ("testMalformedArrayOfMappables", testMalformedArrayOfMappables),
        ("testMappableArrayOfKeys", testMappableArrayOfKeys),
        ("testMappableArrayOfKeysDoesNotThrow", testMappableArrayOfKeysDoesNotThrow),
        ("testMappableArrayOfKeysReturningNil", testMappableArrayOfKeysReturningNil),
        ("testMappableArrayOfKeysThrowsWhenMissing", testMappableArrayOfKeysThrowsWhenMissing),
        ("testNestedMappable", testNestedMappable),
        ("testOptionalMappable", testOptionalMappable),
        ("testValidArrayOfOptionalMappables", testValidArrayOfOptionalMappables),
    ]
}

extension NormalValueTests {
    static let __allTests = [
        ("testArrayOfStrings", testArrayOfStrings),
        ("testEmptyStringJSON", testEmptyStringJSON),
        ("testFallbackMissingKey", testFallbackMissingKey),
        ("testKeyPath", testKeyPath),
        ("testMappingMissingKey", testMappingMissingKey),
        ("testMappingString", testMappingString),
        ("testMappingTimeInterval", testMappingTimeInterval),
        ("testNestedKeysWithInvalidType", testNestedKeysWithInvalidType),
        ("testOptionalPropertyWithFrom", testOptionalPropertyWithFrom),
        ("testPartiallyInvalidArrayOfValues", testPartiallyInvalidArrayOfValues),
    ]
}

extension OptionalValueTests {
    static let __allTests = [
        ("testMappingArrayOfOptionalFieldsPicksNonNil", testMappingArrayOfOptionalFieldsPicksNonNil),
        ("testMappingArrayOfOptionalFieldsReturnsNil", testMappingArrayOfOptionalFieldsReturnsNil),
        ("testMappingOptionalArray", testMappingOptionalArray),
        ("testMappingOptionalExistingArray", testMappingOptionalExistingArray),
        ("testMappingOptionalValue", testMappingOptionalValue),
        ("testMappingStringToClass", testMappingStringToClass),
    ]
}

extension RawRepresentibleValueTests {
    static let __allTests = [
        ("testArrayOfRawValuesWithUnmappableElement", testArrayOfRawValuesWithUnmappableElement),
        ("testArrayOfValuesFailedConvertible", testArrayOfValuesFailedConvertible),
        ("testArrayOfValuesFiltersNilsWithoutDefault", testArrayOfValuesFiltersNilsWithoutDefault),
        ("testArrayOfValuesInsertsDefault", testArrayOfValuesInsertsDefault),
        ("testArrayOfValuesInvalidArray", testArrayOfValuesInvalidArray),
        ("testArrayOfValuesWithMissingKey", testArrayOfValuesWithMissingKey),
        ("testExistingOptionalRawRepresentable", testExistingOptionalRawRepresentable),
        ("testMissingRawRepresentableNumber", testMissingRawRepresentableNumber),
        ("testOptionalArrayDefaultValues", testOptionalArrayDefaultValues),
        ("testOptionalArrayOfRawValuesWithUnmappableElement", testOptionalArrayOfRawValuesWithUnmappableElement),
        ("testOptionalArrayRawValuesMissingKey", testOptionalArrayRawValuesMissingKey),
        ("testOptionalRawRepresentable", testOptionalRawRepresentable),
        ("testRawRepresentable", testRawRepresentable),
        ("testRawRepresentableArrayOfKeys", testRawRepresentableArrayOfKeys),
        ("testRawRepresentableArrayOfKeysReturningNil", testRawRepresentableArrayOfKeysReturningNil),
        ("testRawRepresentableNumber", testRawRepresentableNumber),
        ("testRawRepresentableTypeMismatch", testRawRepresentableTypeMismatch),
        ("testRawRepresentibleArrayOfKeysDoesNotThrow", testRawRepresentibleArrayOfKeysDoesNotThrow),
        ("testRawRepresentibleArrayOfKeysThrowsWhenMissing", testRawRepresentibleArrayOfKeysThrowsWhenMissing),
    ]
}

extension TransformTests {
    static let __allTests = [
        ("testMissingFieldErrorFromTransformation", testMissingFieldErrorFromTransformation),
        ("testToDictionary", testToDictionary),
        ("testToDictionaryInvalid", testToDictionaryInvalid),
        ("testToDictionaryOneInvalid", testToDictionaryOneInvalid),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ConvertibleValueTests.__allTests),
        testCase(CustomTransformationTests.__allTests),
        testCase(ErrorTests.__allTests),
        testCase(InitializerTests.__allTests),
        testCase(JSONSerializationIntegrationTests.__allTests),
        testCase(MappableValueTests.__allTests),
        testCase(NormalValueTests.__allTests),
        testCase(OptionalValueTests.__allTests),
        testCase(RawRepresentibleValueTests.__allTests),
        testCase(TransformTests.__allTests),
    ]
}
#endif
