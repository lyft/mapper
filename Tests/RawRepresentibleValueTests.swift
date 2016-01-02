import Foundation
import Mapper
import XCTest

final class RawRepresentibleValueTests: XCTestCase {
    func testRawRepresentable() {
        struct Test: Mappable {
            let suit: Suits
            init(map: Mapper) throws {
                try self.suit = map.from("suit")
            }
        }

        enum Suits: String {
            case Hearts = "hearts"
        }

#if os(Linux)
        let test = Test.from(["suit": "hearts"])
        XCTAssertNil(test)
#else
        let test = Test.from(["suit": "hearts"])!
        XCTAssertTrue(test.suit == .Hearts)
#endif
    }

    func testRawRepresentableNumber() {
        struct Test: Mappable {
            let value: Value
            init(map: Mapper) throws {
                try self.value = map.from("value")
            }
        }

        enum Value: Int {
            case First = 1
        }

#if os(Linux)
        let test = Test.from(["value": 1])
        XCTAssertNil(test)
#else
        let test = Test.from(["value": 1])!
        XCTAssertTrue(test.value == .First)
#endif
    }

    func testMissingRawRepresentableNumber() {
        struct Test: Mappable {
            let value: Value
            init(map: Mapper) throws {
                try self.value = map.from("value")
            }
        }

        enum Value: Int {
            case First = 1
        }

        let test = Test.from(NSDictionary())
        XCTAssertNil(test)
    }

    func testOptionalRawRepresentable() {
        struct Test: Mappable {
            let value: Value?
            init(map: Mapper) throws {
                self.value = map.optionalFrom("value")
            }
        }

        enum Value: Int {
            case First = 1
        }

        let test = Test.from(NSDictionary())!
        XCTAssertNil(test.value)
    }

    func testExistingOptionalRawRepresentable() {
        struct Test: Mappable {
            let value: Value?
            init(map: Mapper) throws {
                self.value = map.optionalFrom("value")
            }
        }

        enum Value: Int {
            case First = 1
        }

        let test = Test.from(["value": 1])!
#if os(Linux)
        XCTAssertNil(test.value)
#else
        XCTAssertTrue(test.value == .First)
#endif
    }

    func testRawRepresentableTypeMismatch() {
        struct Test: Mappable {
            let value: Value?
            init(map: Mapper) throws {
                self.value = map.optionalFrom("value")
            }
        }

        enum Value: Int {
            case First = 1
        }

        let test = Test.from(["value": "not an int"])!
        XCTAssertNil(test.value)
    }

    func testRawRepresentableArrayOfKeys() {
        struct Test: Mappable {
            let value: Value?
            init(map: Mapper) throws {
                self.value = map.optionalFrom(["a", "b"])
            }
        }

        enum Value: String {
            case First = "hi"
        }

        let test = Test.from(["a": "nope", "b": "hi"])!
#if os(Linux)
        XCTAssertNil(test.value)
#else
        XCTAssertTrue(test.value == .First)
#endif
    }
}

extension RawRepresentibleValueTests: XCTestCaseProvider {
    var allTests: [(String, () -> Void)] {
        return [
            ("testRawRepresentable", testRawRepresentable),
            ("testRawRepresentableNumber", testRawRepresentableNumber),
            ("testMissingRawRepresentableNumber", testMissingRawRepresentableNumber),
            ("testOptionalRawRepresentable", testOptionalRawRepresentable),
            ("testExistingOptionalRawRepresentable", testExistingOptionalRawRepresentable),
            ("testRawRepresentableTypeMismatch", testRawRepresentableTypeMismatch),
            ("testRawRepresentableArrayOfKeys", testRawRepresentableArrayOfKeys),
        ]
    }
}
