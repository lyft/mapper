import Foundation
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

        let test = Test.from(["url": "https://google.com"])
#if os(Linux)
        XCTAssertFalse(test?.URL.host == "google.com")
#else
        XCTAssertTrue(test?.URL.host == "google.com")
#endif
    }

    func testOptionalURL() {
        struct Test: Mappable {
            let URL: NSURL?
            init(map: Mapper) throws {
                self.URL = map.optionalFrom("url")
            }
        }

        let test = Test.from(["url": "https://google.com"])
#if os(Linux)
        XCTAssertFalse(test?.URL?.host == "google.com")
#else
        XCTAssertTrue(test?.URL?.host == "google.com")
#endif
    }

    func testInvalidURL() {
        struct Test: Mappable {
            let URL: NSURL?
            init(map: Mapper) throws {
                self.URL = map.optionalFrom("url")
            }
        }

        let test = Test.from(["url": "##"])!
        XCTAssertNil(test.URL)
    }

    func testArrayOfConvertibles() {
        struct Test: Mappable {
            let URLs: [NSURL]
            init(map: Mapper) throws {
                try self.URLs = map.from("urls")
            }
        }

        let test = Test.from(["urls": ["https://google.com", "example.com"]])
#if os(Linux)
        XCTAssertFalse(test?.URLs.count == 2)
#else
        XCTAssertTrue(test?.URLs.count == 2)
#endif
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

        let test = Test.from(["urls": ["https://google.com", "example.com"]])
#if os(Linux)
        XCTAssertFalse(test?.URLs?.count == 2)
#else
        XCTAssertTrue(test?.URLs?.count == 2)
#endif
    }

    func testInvalidArrayOfConvertibles() {
        struct Test: Mappable {
            let URLs: [NSURL]
            init(map: Mapper) throws {
                try self.URLs = map.from("urls")
            }
        }

        let test = Test.from(["urls": "not an array"])
        XCTAssertNil(test)
    }

    func testInvalidArrayOfOptionalConvertibles() {
        struct Test: Mappable {
            let URLs: [NSURL]?
            init(map: Mapper) throws {
                self.URLs = map.optionalFrom("urls")
            }
        }

        let test = Test.from(["urls": "not an array"])!
        XCTAssertNil(test.URLs)
    }

    func testConvertibleArrayOfKeys() {
        struct Test: Mappable {
            let URL: NSURL?
            init(map: Mapper) throws {
                self.URL = map.optionalFrom(["a", "b"])
            }
        }

        let test = Test.from(["a": "##", "b": "example.com"])!
#if os(Linux)
        XCTAssertFalse(test.URL?.absoluteString == "example.com")
#else
        XCTAssertTrue(test.URL?.absoluteString == "example.com")
#endif
    }
}

extension ConvertibleValueTests: XCTestCaseProvider {
    var allTests: [(String, () -> Void)] {
        return [
            ("testCreatingURL", testCreatingURL),
            ("testOptionalURL", testOptionalURL),
            ("testInvalidURL", testInvalidURL),
            ("testArrayOfConvertibles", testArrayOfConvertibles),
            ("testOptionalArrayOfConvertibles", testOptionalArrayOfConvertibles),
            ("testExistingOptionalArrayOfConvertibles", testExistingOptionalArrayOfConvertibles),
            ("testInvalidArrayOfConvertibles", testInvalidArrayOfConvertibles),
            ("testInvalidArrayOfOptionalConvertibles", testInvalidArrayOfOptionalConvertibles),
            ("testConvertibleArrayOfKeys", testConvertibleArrayOfKeys),
        ]
    }
}
