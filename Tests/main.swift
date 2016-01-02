import Foundation
import XCTest

#if os(Linux)
import Mapper

XCTMain([
    ConvertibleValueTests(),
    CustomTransformationTests(),
    InitializerTests(),
    MappableValueTests(),
    NormalValueTests(),
    OptionalValueTests(),
    RawRepresentibleValueTests(),
    TransformTests(),
])

extension Mappable {
    public static func from<T, U>(JSON: [T: U]) -> Self? {
        return self.from(JSON.bridge())
    }

    public static func from(JSON: [String: [[String: String]]]) -> Self? {
        let dictionary = NSMutableDictionary()
        for (key, array) in JSON {
            let items = NSMutableArray()
            for dictionary in array {
                items.addObject(dictionary.bridge())
            }

            dictionary[key.bridge()] = items
        }

        return self.from(dictionary)
    }

    public static func from(JSON: [String: [String]]) -> Self? {
        let dictionary = NSMutableDictionary()
        for (key, array) in JSON {
            let items = NSMutableArray()
            for string in array {
                    items.addObject(string.bridge())
            }
            dictionary[key.bridge()] = items
        }
        return self.from(dictionary)
    }
}
#else
public protocol XCTestCaseProvider {
    var allTests: [(String, () -> Void)] { get }
}

extension XCTestCase {
    override public func tearDown() {
        if let provider = self as? XCTestCaseProvider {
            provider.assertContainsTest(invocation!.selector.description)
        } else {
            XCTFail("XCTestCase must conform to XCTestCaseProvider")
        }

        super.tearDown()
    }
}

extension XCTestCaseProvider {
    private func assertContainsTest(name: String) {
        let contains = self.allTests.contains({ test in
            return test.0 == name
        })

        XCTAssert(contains, "Test '\(name)' is missing from the allTests array")
    }
}
#endif
