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
    
    func testThrowingMapErrorForMissingField() {
        struct Test: Mappable {
            let field1: String
            let field2: String
            let field3: String
            
            init(map: Mapper) throws {
                try self.field1 = map.from("field1")
                try self.field2 = map.from("field2")
                try self.field3 = map.from("field3")
            }
        }
        
        let mapper = Mapper(JSON: ["field1": "Hi", "field3": "Yes"])
        
        
        do {
            let _ = try Test(map: mapper)
        } catch MapperError.MapError(let message) {
            XCTAssertEqual(message, "Can't convert value of field 'field2' to String")
        } catch {
            XCTFail("Catched error \"\(error)\", but not the expected: \"\(MapperError.MapError)\"")
        }
    }
}
