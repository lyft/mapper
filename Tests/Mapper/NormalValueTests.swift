import Mapper
import XCTest

final class NormalValueTests: XCTestCase {
    func testMappingString() {
        struct Test: Mappable {
            let string: String
            init(map: Mapper) throws {
                try self.string = map.from("string")
            }
        }

        let test = try! Test(map: Mapper(JSON: ["string": "Hello"]))
        XCTAssertTrue(test.string == "Hello")
    }

    func testMappingMissingKey() {
        struct Test: Mappable {
            let string: String
            init(map: Mapper) throws {
                try self.string = map.from("foo")
            }
        }

        let test = try? Test(map: Mapper(JSON: [:]))
        XCTAssertNil(test)
    }

    func testFallbackMissingKey() {
        struct Test: Mappable {
            let string: String
            init(map: Mapper) throws {
                self.string = map.optionalFrom("foo") ?? "Hello"
            }
        }

        let test = try! Test(map: Mapper(JSON: [:]))
        XCTAssertTrue(test.string == "Hello")
    }

    func testArrayOfStrings() {
        struct Test: Mappable {
            let strings: [String]
            init(map: Mapper) throws {
                try self.strings = map.from("strings")
            }
        }

        let test = try! Test(map: Mapper(JSON: ["strings": ["first", "second"]]))
        XCTAssertTrue(test.strings.count == 2)
    }

    func testEmptyStringJSON() {
        struct Test: Mappable {
            let JSON: AnyObject
            init(map: Mapper) throws {
                try self.JSON = map.from("")
            }
        }

        let JSON = ["a": "b", "c": "d"]
        let test = try! Test(map: Mapper(JSON: JSON))
        XCTAssertTrue((test.JSON as! [String: String]) == JSON)
    }

    func testKeyPath() {
        struct Test: Mappable {
            let string: String
            init(map: Mapper) throws {
                try self.string = map.from("foo.bar")
            }
        }

        let test = try! Test(map: Mapper(JSON: ["foo": ["bar": "baz"]]))
        XCTAssertTrue(test.string == "baz")
    }

    func testPartiallyInvalidArrayOfValues() {
        struct Test: Mappable {
            let strings: [String]
            init(map: Mapper) throws {
                try self.strings = map.from("strings")
            }
        }

        let test = try? Test(map: Mapper(JSON: ["strings": ["hi", 1]]))
        XCTAssertNil(test)
    }
}
