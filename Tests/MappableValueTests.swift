import Mapper
import XCTest

final class MappableValueTests: XCTestCase {
    func testNestedMappable() {
#if !os(Linux)
        struct Test: Mappable {
            let nest: Nested
            init(map: Mapper) throws {
                try self.nest = map.from("nest")
            }
        }

        struct Nested: Mappable {
            let string: String
            init(map: Mapper) throws {
                try self.string = map.from("string")
            }
        }

        let test = Test.from(["nest": ["string": "hello"]])
        XCTAssertTrue(test?.nest.string == "hello")
#endif
    }

    func testArrayOfMappables() {
        struct Test: Mappable {
            let nests: [Nested]
            init(map: Mapper) throws {
                try self.nests = map.from("nests")
            }
        }

        struct Nested: Mappable {
            let string: String
            init(map: Mapper) throws {
                try self.string = map.from("string")
            }
        }

        let test = Test.from(["nests": [["string": "first"], ["string": "second"]]])
#if os(Linux)
        XCTAssertFalse(test?.nests.count == 2)
#else
        XCTAssertTrue(test?.nests.count == 2)
#endif
    }

    func testOptionalMappable() {
        struct Test: Mappable {
            let nest: Nested?
            init(map: Mapper) throws {
                self.nest = map.optionalFrom("foo")
            }
        }

        struct Nested: Mappable {
            init(map: Mapper) throws {}
        }

        let test = try! Test(map: Mapper(JSON: [:]))
        XCTAssertNil(test.nest)
    }

    func testInvalidArrayOfMappables() {
        struct Test: Mappable {
            let nests: [Nested]
            init(map: Mapper) throws {
                try self.nests = map.from("nests")
            }
        }

        struct Nested: Mappable {
            let string: String
            init(map: Mapper) throws {
                try self.string = map.from("string")
            }
        }

        let test = Test.from(["nests": "not an array"])
        XCTAssertNil(test)
    }

    func testValidArrayOfOptionalMappables() {
        struct Test: Mappable {
            let nests: [Nested]?
            init(map: Mapper) throws {
                self.nests = map.optionalFrom("nests")
            }
        }

        struct Nested: Mappable {
            let string: String
            init(map: Mapper) throws {
                try self.string = map.from("string")
            }
        }

        let test = Test.from(["nests": [["string": "first"], ["string": "second"]]])
#if os(Linux)
        XCTAssertFalse(test?.nests?.count == 2)
#else
        XCTAssertTrue(test?.nests?.count == 2)
#endif
    }

    func testMalformedArrayOfMappables() {
        struct Test: Mappable {
            let nests: [Nested]
            init(map: Mapper) throws {
                try self.nests = map.from("nests")
            }
        }

        struct Nested: Mappable {
            let string: String
            init(map: Mapper) throws {
                try self.string = map.from("string")
            }
        }

        let test = Test.from(["nests": [["foo": "first"], ["string": "second"]]])
        XCTAssertNil(test)
    }

    func testInvalidArrayOfOptionalMappables() {
        struct Test: Mappable {
            let nests: [Nested]?
            init(map: Mapper) throws {
                self.nests = map.optionalFrom("nests")
            }
        }

        struct Nested: Mappable {
            let string: String
            init(map: Mapper) throws {
                try self.string = map.from("string")
            }
        }

        let test = Test.from(["nests": "not an array"])!
        XCTAssertNil(test.nests)
    }

    func testMappableArrayOfKeys() {
#if !os(Linux)
        struct Test: Mappable {
            let nest: Nested?
            init(map: Mapper) throws {
                self.nest = map.optionalFrom(["a", "b"])
            }
        }

        struct Nested: Mappable {
            let string: String
            init(map: Mapper) throws {
                try self.string = map.from("string")
            }
        }

        let test = Test.from(["a": ["foo": "bar"], "b": ["string": "hi"]])
        XCTAssertTrue(test?.nest?.string == "hi")
#endif
    }
}

extension MappableValueTests: XCTestCaseProvider {
    var allTests: [(String, () -> Void)] {
        return [
            ("testNestedMappable", testNestedMappable),
            ("testArrayOfMappables", testArrayOfMappables),
            ("testOptionalMappable", testOptionalMappable),
            ("testInvalidArrayOfMappables", testInvalidArrayOfMappables),
            ("testValidArrayOfOptionalMappables", testValidArrayOfOptionalMappables),
            ("testMalformedArrayOfMappables", testMalformedArrayOfMappables),
            ("testInvalidArrayOfOptionalMappables", testInvalidArrayOfOptionalMappables),
            ("testMappableArrayOfKeys", testMappableArrayOfKeys),
        ]
    }
}
