import Mapper
import XCTest

private struct TestExtension {
    let string: String
}

extension TestExtension: Mappable {
    init(map: Mapper) throws {
        try self.string = map.from("string")
    }
}

final class InitializerTests: XCTestCase {

    // MARK: from NSDictionary

    func testCreatingInvalidFromJSON() {
        struct Test: Mappable {
            let string: String
            init(map: Mapper) throws {
                try self.string = map.from("foo")
            }
        }

        let test = Test.from([:])
        XCTAssertNil(test)
    }

    func testCreatingValidFromJSON() {
        struct Test: Mappable {
            let string: String
            init(map: Mapper) throws {
                try self.string = map.from("string")
            }
        }

        let test = Test.from(["string": "Hi"])
        XCTAssertTrue(test?.string == "Hi")
    }

    // MARK: from NSArray

    func testCreatingFromArrayOfJSON() {
        struct Test: Mappable {
            let string: String
            init(map: Mapper) throws {
                try self.string = map.from("string")
            }
        }

        let tests = Test.from([["string": "Hi"], ["string": "Bye"]])
        XCTAssertTrue(tests?.count == 2)
    }

    func testCreatingFromPartiallyInvalidArrayOfJSON() {
        struct Test: Mappable {
            let string: String
            init(map: Mapper) throws {
                try self.string = map.from("string")
            }
        }

        let tests = Test.from([["string": "Hi"], ["nope": "Bye"]])
        XCTAssertNil(tests)
    }

    func testCreatingFromInvalidArray() {
        struct Test: Mappable {
            let string: String
            init(map: Mapper) throws {
                try self.string = map.from("string")
            }
        }

        let tests = Test.from(["hi"])
        XCTAssertNil(tests)
    }

    // MARK: Testing http://www.openradar.me/23376350

    func testCreatingWithConformanceInExtension() {
        let test = TestExtension.from(["string": "Hi"])
        XCTAssertTrue(test?.string == "Hi")
    }
}
