import Mapper
import XCTest

final class OptionalValueTests: XCTestCase {
    func testMappingStringToClass() {
        final class Test: Mappable {
            let string: String
            required init(map: Mapper) throws {
                self.string = map.optionalFrom("string") ?? ""
            }
        }

        let test = Test.from(["string": "Hello"])!
#if os(Linux)
        XCTAssertTrue(test.string.isEmpty)
#else
        XCTAssertTrue(test.string == "Hello")
#endif
    }

    func testMappingOptionalValue() {
        struct Test: Mappable {
            let string: String?
            init(map: Mapper) throws {
                self.string = map.optionalFrom("foo")
            }
        }

        let test = try! Test(map: Mapper(JSON: [:]))
        XCTAssertNil(test.string)
    }

    func testMappingOptionalArray() {
        struct Test: Mappable {
            let string: [String]?
            init(map: Mapper) throws {
                self.string = map.optionalFrom("foo")
            }
        }

        let test = try! Test(map: Mapper(JSON: [:]))
        XCTAssertNil(test.string)
    }

    func testMappingOptionalExistingArray() {
        struct Test: Mappable {
            let strings: [String]?
            init(map: Mapper) throws {
                self.strings = map.optionalFrom("strings")
            }
        }

        let test = Test.from(["strings": ["first", "second"]])!
#if os(Linux)
            XCTAssertNil(test.strings)
#else
            XCTAssertTrue(test.strings!.count == 2)
#endif
    }

    func testMappingArrayOfOptionalFieldsPicksNonNil() {
        struct Test: Mappable {
            let string: String?
            init(map: Mapper) throws {
                self.string = map.optionalFrom([
                    "a",
                    "b",
                    "c",
                ])
            }
        }

        let test = Test.from(["b": "foo"])!
#if os(Linux)
        XCTAssertNil(test.string)
#else
        XCTAssertTrue(test.string == "foo")
#endif
    }

    func testMappingArrayOfOptionalFieldsReturnsNil() {
        struct Test: Mappable {
            let string: String?
            init(map: Mapper) throws {
                self.string = map.optionalFrom([
                    "a",
                    "b",
                ])
            }
        }

        let test = try! Test(map: Mapper(JSON: [:]))
        XCTAssertNil(test.string)
    }

    // This is horrible. But currently, because of having multiple generic functions with
    // similar type constraints, Swift incorrect infers the types of this. This is here
    // as a sanity check. Once this test breaks we *could* remove `optionalFrom(fields: [String])`
    // which was added to work around this problem.
    func testNilCoalescingIsBroken() {
        struct Test: Mappable {
            let string: String?
            init(map: Mapper) throws {
                self.string = map.optionalFrom("a") ?? map.optionalFrom("b") ?? map.optionalFrom("c")
            }
        }

        let test = Test.from(["b": "foo"])!
        XCTAssertNil(test.string)
    }
}

extension OptionalValueTests: XCTestCaseProvider {
    var allTests: [(String, () -> Void)] {
        return [
            ("testMappingStringToClass", testMappingStringToClass),
            ("testMappingOptionalValue", testMappingOptionalValue),
            ("testMappingOptionalArray", testMappingOptionalArray),
            ("testMappingOptionalExistingArray", testMappingOptionalExistingArray),
            ("testMappingArrayOfOptionalFieldsPicksNonNil", testMappingArrayOfOptionalFieldsPicksNonNil),
            ("testMappingArrayOfOptionalFieldsReturnsNil", testMappingArrayOfOptionalFieldsReturnsNil),
            ("testNilCoalescingIsBroken", testNilCoalescingIsBroken),
        ]
    }
}
