import Mapper
import XCTest

final class MappableValueTests: XCTestCase {
    func testNestedMappable() {
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

        let test = try! Test(map: Mapper(JSON: ["nest": ["string": "hello"]]))
        XCTAssertTrue(test.nest.string == "hello")
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

        let test = try! Test(map: Mapper(JSON: ["nests": [["string": "first"], ["string": "second"]]]))
        XCTAssertTrue(test.nests.count == 2)
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

        let test = try? Test(map: Mapper(JSON: ["nests": "not an array"]))
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

        let test = try! Test(map: Mapper(JSON: ["nests": [["string": "first"], ["string": "second"]]]))
        XCTAssertTrue(test.nests?.count == 2)
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

        let test = try? Test(map: Mapper(JSON: ["nests": [["foo": "first"], ["string": "second"]]]))
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

        let test = try! Test(map: Mapper(JSON: ["nests": "not an array"]))
        XCTAssertNil(test.nests)
    }

    func testMappableArrayOfKeys() {
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

        let test = try! Test(map: Mapper(JSON: ["a": ["foo": "bar"], "b": ["string": "hi"]]))
        XCTAssertTrue(test.nest?.string == "hi")
    }

    func testMappableArrayOfKeysReturningNil() {
        struct Test: Mappable {
            let nest: Nested?
            init(map: Mapper) throws {
                self.nest = map.optionalFrom(["a", "b"])
            }
        }

        struct Nested: Mappable {
            init(map: Mapper) throws {}
        }

        let test = Test.from([:])!
        XCTAssertNil(test.nest)
    }
}
