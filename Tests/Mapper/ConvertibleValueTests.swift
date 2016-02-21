import Mapper
import XCTest

final class ConvertibleValueTests: XCTestCase {
    func testCreatingURL() {
        struct Test: Mappable {
            let URL: NSURL
            init(map: Mapper) throws {
                try self.URL = map.from("url")
            }
        }

        let test = try! Test(map: Mapper(JSON: ["url": "https://google.com"]))
        XCTAssertTrue(test.URL.host == "google.com")
    }

    func testOptionalURL() {
        struct Test: Mappable {
            let URL: NSURL?
            init(map: Mapper) throws {
                self.URL = map.optionalFrom("url")
            }
        }

        let test = try! Test(map: Mapper(JSON: ["url": "https://google.com"]))
        XCTAssertTrue(test.URL?.host == "google.com")
    }

    func testInvalidURL() {
        struct Test: Mappable {
            let URL: NSURL?
            init(map: Mapper) throws {
                self.URL = map.optionalFrom("url")
            }
        }

        let test = try! Test(map: Mapper(JSON: ["url": "##"]))
        XCTAssertNil(test.URL)
    }

    func testArrayOfConvertibles() {
        struct Test: Mappable {
            let URLs: [NSURL]
            init(map: Mapper) throws {
                try self.URLs = map.from("urls")
            }
        }

        let test = try! Test(map: Mapper(JSON: ["urls": ["https://google.com", "example.com"]]))
        XCTAssertTrue(test.URLs.count == 2)
    }

    func testOptionalArrayOfConvertibles() {
        struct Test: Mappable {
            let URLs: [NSURL]?
            init(map: Mapper) throws {
                self.URLs = map.optionalFrom("urls")
            }
        }

        let test = try! Test(map: Mapper(JSON: [:]))
        XCTAssertNil(test.URLs)
    }

    func testExistingOptionalArrayOfConvertibles() {
        struct Test: Mappable {
            let URLs: [NSURL]?
            init(map: Mapper) throws {
                self.URLs = map.optionalFrom("urls")
            }
        }

        let test = try! Test(map: Mapper(JSON: ["urls": ["https://google.com", "example.com"]]))
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
            init(map: Mapper) throws {
                self.URLs = map.optionalFrom("urls")
            }
        }

        let test = try! Test(map: Mapper(JSON: ["urls": "not an array"]))
        XCTAssertNil(test.URLs)
    }

    func testConvertibleArrayOfKeys() {
        struct Test: Mappable {
            let URL: NSURL?
            init(map: Mapper) throws {
                self.URL = map.optionalFrom(["a", "b"])
            }
        }

        let test = try! Test(map: Mapper(JSON: ["a": "##", "b": "example.com"]))
        XCTAssertTrue(test.URL?.absoluteString == "example.com")
    }

    func testConvertibleArrayOfKeysReturnsNil() {
        struct Test: Mappable {
            let URL: NSURL?
            init(map: Mapper) throws {
                self.URL = map.optionalFrom(["a", "b"])
            }
        }

        let test = try! Test(map: Mapper(JSON: [:]))
        XCTAssertNil(test.URL)
    }
}
