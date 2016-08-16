import Mapper
import XCTest

private struct Foo: Convertible {
    static func fromMap(value: AnyObject) throws -> Foo {
        return Foo()
    }
}

private enum NilConvertibleEnum: NilConvertible {
    case NoValue
    case SomeValue

    static func fromMap(value: AnyObject?) throws -> NilConvertibleEnum {
        switch value {
            case .None: return .NoValue
            case .Some(_): return .SomeValue
        }
    }
}

final class ConvertibleValueTests: XCTestCase {
    func testCreatingURL() {
        struct Test: Mappable {
            let URL: NSURL
            init(map: Mapper) throws {
                try self.URL = map.from("url")
            }
        }

        let test = try? Test(map: Mapper(JSON: ["url": "https://google.com"]))
        XCTAssertTrue(test?.URL.host == "google.com")
    }

    func testOptionalURL() {
        struct Test: Mappable {
            let URL: NSURL?
            init(map: Mapper) {
                self.URL = map.optionalFrom("url")
            }
        }

        let test = Test(map: Mapper(JSON: ["url": "https://google.com"]))
        XCTAssertTrue(test.URL?.host == "google.com")
    }

    func testInvalidURL() {
        struct Test: Mappable {
            let URL: NSURL?
            init(map: Mapper) {
                self.URL = map.optionalFrom("url")
            }
        }

        let test = Test(map: Mapper(JSON: ["url": "##"]))
        XCTAssertNil(test.URL)
    }

    func testArrayOfConvertibles() {
        struct Test: Mappable {
            let URLs: [NSURL]
            init(map: Mapper) throws {
                try self.URLs = map.from("urls")
            }
        }

        let test = try? Test(map: Mapper(JSON: ["urls": ["https://google.com", "example.com"]]))
        XCTAssertTrue(test?.URLs.count == 2)
    }

    func testOptionalArrayOfConvertibles() {
        struct Test: Mappable {
            let URLs: [NSURL]?
            init(map: Mapper) {
                self.URLs = map.optionalFrom("urls")
            }
        }

        let test = Test(map: Mapper(JSON: [:]))
        XCTAssertNil(test.URLs)
    }

    func testExistingOptionalArrayOfConvertibles() {
        struct Test: Mappable {
            let URLs: [NSURL]?
            init(map: Mapper) {
                self.URLs = map.optionalFrom("urls")
            }
        }

        let test = Test(map: Mapper(JSON: ["urls": ["https://google.com", "example.com"]]))
        XCTAssertTrue(test.URLs?.count == 2)
    }

    func testInvalidArrayOfConvertibles() {
        struct Test: Mappable {
            let URLs: [NSURL]
            init(map: Mapper) throws {
                try self.URLs = map.from("urls")
            }
        }

        let test = try? Test(map: Mapper(JSON: ["urls": "not an array"]))
        XCTAssertNil(test)
    }

    func testInvalidArrayOfOptionalConvertibles() {
        struct Test: Mappable {
            let URLs: [NSURL]?
            init(map: Mapper) {
                self.URLs = map.optionalFrom("urls")
            }
        }

        let test = Test(map: Mapper(JSON: ["urls": "not an array"]))
        XCTAssertNil(test.URLs)
    }

    func testConvertibleArrayOfKeys() {
        struct Test: Mappable {
            let URL: NSURL?
            init(map: Mapper) {
                self.URL = map.optionalFrom(["a", "b"])
            }
        }

        let test = Test(map: Mapper(JSON: ["a": "##", "b": "example.com"]))
        XCTAssertTrue(test.URL?.absoluteString == "example.com")
    }

    func testConvertibleArrayOfKeysReturnsNil() {
        struct Test: Mappable {
            let URL: NSURL?
            init(map: Mapper) {
                self.URL = map.optionalFrom(["a", "b"])
            }
        }

        let test = Test(map: Mapper(JSON: [:]))
        XCTAssertNil(test.URL)
    }

    func testDictionaryConvertible() {
        struct Test: Mappable {
            let dictionary: [String: Int]

            init(map: Mapper) throws {
                try self.dictionary = map.from("foo")
            }
        }

        let test = Test.from(["foo": ["key": 1]])
        XCTAssertTrue(test?.dictionary["key"] == 1)
    }

    func testOptionalDictionaryConvertible() {
        struct Test: Mappable {
            let dictionary: [String: Int]?

            init(map: Mapper) throws {
                self.dictionary = map.optionalFrom("foo")
            }
        }

        let test = Test.from(["foo": ["key": 1]])
        XCTAssertTrue(test?.dictionary?["key"] == 1)
    }

    func testDictionaryOfConvertibles() {
        struct Test: Mappable {
            let dictionary: [String: Foo]

            init(map: Mapper) throws {
                try self.dictionary = map.from("foo")
            }
        }

        let test = Test.from(["foo": ["key": "value"]])
        XCTAssertTrue(test?.dictionary.count > 0)
    }

    func testOptionalDictionaryConvertibleNil() {
        struct Test: Mappable {
            let dictionary: [String: Int]?

            init(map: Mapper) throws {
                self.dictionary = map.optionalFrom("foo")
            }
        }

        do {
            let test = try Test(map: Mapper(JSON: ["foo": ["key": "not int"]]))
            XCTAssertNil(test.dictionary)
        } catch {
            XCTFail("Couldn't create Test")
        }
    }

    func testDictionaryConvertibleSingleInvalid() {
        struct Test: Mappable {
            let dictionary: [String: Int]

            init(map: Mapper) throws {
                try self.dictionary = map.from("foo")
            }
        }

        let test = Test.from(["foo": ["key": 1, "key2": "not int"]])
        XCTAssertNil(test)
    }

    func testDictionaryButInvalidJSON() {
        struct Test: Mappable {
            let dictionary: [String: Int]

            init(map: Mapper) throws {
                try self.dictionary = map.from("foo")
            }
        }

        let test = Test.from(["foo": "not a dictionary"])
        XCTAssertNil(test)
    }

    func testNilConvertibleWithNilField() {
        struct Test: Mappable {
            let enumField: NilConvertibleEnum

            init(map: Mapper) throws {
                try self.enumField = map.from("foo")
            }
        }

        let test = Test.from([:])
        XCTAssert(test?.enumField == .NoValue)
    }

    func testNilConvertibleWithNonNilField() {
        struct Test: Mappable {
            let enumField: NilConvertibleEnum

            init(map: Mapper) throws {
                try self.enumField = map.from("foo")
            }
        }

        let test = Test.from(["foo" : "bar"])
        XCTAssert(test?.enumField == .SomeValue)
    }
}
