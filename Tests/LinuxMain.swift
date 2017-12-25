import Mapper
import XCTest

XCTMain([
    testCase(ConvertibleValueTests.allTests),
    testCase(CustomTransformationTests.allTests),
    testCase(ErrorTests.allTests),
    testCase(InitializerTests.allTests),
    testCase(JSONSerializationIntegrationTests.allTests),
    testCase(MappableValueTests.allTests),
    testCase(NormalValueTests.allTests),
    testCase(OptionalValueTests.allTests),
    testCase(RawRepresentibleValueTests.allTests),
    testCase(TransformTests.allTests),
])
