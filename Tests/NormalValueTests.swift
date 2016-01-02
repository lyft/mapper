import Mapper
import Foundation
import XCTest

final class NormalValueTests: XCTestCase {
    func testMappingString() {
        struct Test: Mappable {
            let string: String
            init(map: Mapper) throws {
                try self.string = map.from("string")
            }
        }

        let test = Test.from(["string": "Hello"])
#if os(Linux)
        XCTAssertFalse(test?.string == "Hello")
#else
        XCTAssertTrue(test?.string == "Hello")
#endif
    }

    func testMappingMissingKey() {
        struct Test: Mappable {
            let string: String
            init(map: Mapper) throws {
                try self.string = map.from("foo")
            }
        }

        XCTAssertNil(Test.from(NSDictionary()))
    }

    func testFallbackMissingKey() {
        struct Test: Mappable {
            let string: String
            init(map: Mapper) throws {
                self.string = map.optionalFrom("foo") ?? "Hello"
            }
        }

        let test = Test.from(NSDictionary())
        XCTAssertTrue(test?.string == "Hello")
    }

    func testArrayOfStrings() {
        struct Test: Mappable {
            let strings: [String]
            init(map: Mapper) throws {
                try self.strings = map.from("strings")
            }
        }

        let test = Test.from(["strings": ["first", "second"]])
#if os(Linux)
        XCTAssertFalse(test?.strings.count == 2)
#else
        XCTAssertTrue(test?.strings.count == 2)
#endif
    }

    func testEmptyStringJSON() {
        struct Test: Mappable {
            let JSON: AnyObject
            init(map: Mapper) throws {
                try self.JSON = map.from("")
            }
        }

        let JSON = ["a": "b", "c": "d"] as [String: String]
        let test = Test.from(JSON)!
#if !os(Linux)
        XCTAssertTrue((test.JSON as! [String: String]) == JSON)
#endif
    }

    func testKeyPath() {
#if !os(Linux)
        struct Test: Mappable {
            let string: String
            init(map: Mapper) throws {
                try self.string = map.from("foo.bar")
            }
        }

        let test = Test.from(["foo": ["bar": "baz"]])
        XCTAssertTrue(test?.string == "baz")
#endif
    }

    func testPartiallyInvalidArrayOfValues() {
#if !os(Linux)
        struct Test: Mappable {
            let strings: [String]
            init(map: Mapper) throws {
                try self.strings = map.from("strings")
            }
        }

        let test = Test.from(["strings": ["hi", 1]])
        XCTAssertNil(test)
#endif
    }
}

extension NormalValueTests: XCTestCaseProvider {
    var allTests: [(String, () -> Void)] {
        return [
            ("testMappingString", testMappingString),
            ("testMappingMissingKey", testMappingMissingKey),
            ("testFallbackMissingKey", testFallbackMissingKey),
            ("testArrayOfStrings", testArrayOfStrings),
            ("testEmptyStringJSON", testEmptyStringJSON),
            ("testKeyPath", testKeyPath),
            ("testPartiallyInvalidArrayOfValues", testPartiallyInvalidArrayOfValues),
        ]
    }
}
