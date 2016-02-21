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

        let test = try! Test(map: Mapper(JSON: ["string": "Hello"]))
        XCTAssertTrue(test.string == "Hello")
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

        let test = try! Test(map: Mapper(JSON: ["strings": ["first", "second"]]))
        XCTAssertTrue(test.strings!.count == 2)
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
        XCTAssertTrue(test.string == "foo")
    }

    func testMappingArrayOfOptionalFieldsReturnsNil() {
        struct Test: Mappable {
            let string: String?
            init(map: Mapper) throws {
                self.string = map.optionalFrom(["a", "b"])
            }
        }

        let test = Test.from([:])!
        XCTAssertNil(test.string)
    }
}
