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

    // MARK: from NSArray as Optional

    func testCreatingFromArrayOfJSON() {
        struct Test: Mappable {
            let string: String
            init(map: Mapper) throws {
                try self.string = map.from("string")
            }
        }

        let tests: [Test]? = Test.from([["string": "Hi"], ["string": "Bye"]])
        XCTAssertTrue(tests?.count == 2)
    }

    func testCreatingFromPartiallyInvalidArrayOfJSON() {
        struct Test: Mappable {
            let string: String
            init(map: Mapper) throws {
                try self.string = map.from("string")
            }
        }

        let tests: [Test]? = Test.from([["string": "Hi"], ["nope": "Bye"]])
        XCTAssertNil(tests)
    }

    func testCreatingFromInvalidArray() {
        struct Test: Mappable {
            let string: String
            init(map: Mapper) throws {
                try self.string = map.from("string")
            }
        }

        let tests: [Test]? = Test.from(["hi"])
        XCTAssertNil(tests)
    }
    
    // MARK: from NSArray as non-Optional
    
    func testCreatingNonOptionalFromArrayOfJSON() {
        struct Test: Mappable {
            let string: String
            init(map: Mapper) throws {
                try self.string = map.from("string")
            }
        }
        
        let tests: [Test] = Test.from([["string": "Hi"], ["string": "Bye"]])
        XCTAssertTrue(tests.count == 2)
    }
    
    func testCreatingNonOptionalFromPartiallyInvalidArrayOfJSON() {
        struct Test: Mappable {
            let string: String
            init(map: Mapper) throws {
                try self.string = map.from("string")
            }
        }
        
        let tests: [Test] = Test.from([["string": "Hi"], ["nope": "Bye"]])
        XCTAssertTrue(tests.count == 1)
    }
    
    func testCreatingNonOptionalFromInvalidArray() {
        struct Test: Mappable {
            let string: String
            init(map: Mapper) throws {
                try self.string = map.from("string")
            }
        }
        
        let tests: [Test] = Test.from(["hi"])
        XCTAssertTrue(tests.count == 0)
    }

    // MARK: Testing http://www.openradar.me/23376350

    func testCreatingWithConformanceInExtension() {
        let test = TestExtension.from(["string": "Hi"])
        XCTAssertTrue(test?.string == "Hi")
    }
}
