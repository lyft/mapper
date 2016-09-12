import Mapper
import XCTest

final class RawRepresentibleValueTests: XCTestCase {
    func testRawRepresentable() {
        struct Test: Mappable {
            let suit: Suits
            init(map: Mapper) throws {
                try self.suit = map.from("suit")
            }
        }

        enum Suits: String {
            case Hearts = "hearts"
        }

        let test = try? Test(map: Mapper(JSON: ["suit": "hearts"]))
        XCTAssertTrue(test?.suit == .Hearts)
    }

    func testRawRepresentableNumber() {
        struct Test: Mappable {
            let value: Value
            init(map: Mapper) throws {
                try self.value = map.from("value")
            }
        }

        enum Value: Int {
            case first = 1
        }

        let test = try? Test(map: Mapper(JSON: ["value": 1]))
        XCTAssertTrue(test?.value == .first)
    }

    func testMissingRawRepresentableNumber() {
        struct Test: Mappable {
            let value: Value
            init(map: Mapper) throws {
                try self.value = map.from("value")
            }
        }

        enum Value: Int {
            case first = 1
        }

        let test = try? Test(map: Mapper(JSON: [:]))
        XCTAssertNil(test)
    }

    func testOptionalRawRepresentable() {
        struct Test: Mappable {
            let value: Value?
            init(map: Mapper) {
                self.value = map.optionalFrom("value")
            }
        }

        enum Value: Int {
            case first = 1
        }

        let test = Test(map: Mapper(JSON: [:]))
        XCTAssertNil(test.value)
    }

    func testExistingOptionalRawRepresentable() {
        struct Test: Mappable {
            let value: Value?
            init(map: Mapper) {
                self.value = map.optionalFrom("value")
            }
        }

        enum Value: Int {
            case first = 1
        }

        let test = Test(map: Mapper(JSON: ["value": 1]))
        XCTAssertTrue(test.value == .first)
    }

    func testRawRepresentableTypeMismatch() {
        struct Test: Mappable {
            let value: Value?
            init(map: Mapper) {
                self.value = map.optionalFrom("value")
            }
        }

        enum Value: Int {
            case first = 1
        }

        let test = Test(map: Mapper(JSON: ["value": "not an int"]))
        XCTAssertNil(test.value)
    }

    func testRawRepresentableArrayOfKeys() {
        struct Test: Mappable {
            let value: Value?
            init(map: Mapper) {
                self.value = map.optionalFrom(["a", "b"])
            }
        }

        enum Value: String {
            case First = "hi"
        }

        let test = Test(map: Mapper(JSON: ["a": "nope", "b": "hi"]))
        XCTAssertTrue(test.value == .First)
    }

    func testRawRepresentableArrayOfKeysReturningNil() {
        struct Test: Mappable {
            let value: Value?
            init(map: Mapper) {
                self.value = map.optionalFrom(["a", "b"])
            }
        }

        enum Value: String {
            case First = "hi"
        }

        let test = Test(map: Mapper(JSON: [:]))
        XCTAssertNil(test.value)
    }

    func testArrayOfValuesWithMissingKey() {
        struct Test: Mappable {
            let value: [Value]
            init(map: Mapper) throws {
                self.value = try map.from("a")
            }
        }

        enum Value: String {
            case First = "hi"
        }

        do {
            _ = try Test(map: Mapper(JSON: [:]))
            XCTFail("Expected initialization to fail")
        } catch MapperError.missingFieldError(let field) {
            XCTAssertEqual(field, "a")
        } catch let error {
            XCTFail("Expected only missing field error, got \(error)")
        }
    }

    func testArrayOfValuesInvalidArray() {
        struct Test: Mappable {
            let values: [Value]
            init(map: Mapper) throws {
                self.values = try map.from("a")
            }
        }

        enum Value: String {
            case First = "hi"
        }

        do {
            _ = try Test(map: Mapper(JSON: ["a": 1]))
            XCTFail("Expected initialization to fail")
        } catch MapperError.typeMismatchError(let field, let value, let type) {
            XCTAssertEqual(field, "a")
            XCTAssertEqual(value as? Int, 1)
            XCTAssert(type == [Any].self)
        } catch let error {
            XCTFail("Expected only missing field error, got \(error)")
        }
    }

    func testArrayOfValuesFailedConvertible() {
        struct Test: Mappable {
            let values: [Value]
            init(map: Mapper) throws {
                self.values = try map.from("a")
            }
        }

        enum Value: String {
            case First = "hi"
        }

        do {
            _ = try Test(map: Mapper(JSON: ["a": [1]]))
            XCTFail("Expected initialization to fail")
        } catch MapperError.convertibleError(let value, let type) {
            XCTAssertEqual(value as? Int, 1)
            XCTAssert(type == String.self)
        } catch let error {
            XCTFail("Expected only missing field error, got \(error)")
        }
    }

    func testArrayOfValuesFiltersNilsWithoutDefault() {
        struct Test: Mappable {
            let values: [Value]
            init(map: Mapper) throws {
                self.values = try map.from("a")
            }
        }

        enum Value: String {
            case First = "hi"
        }

        do {
            let test = try Test(map: Mapper(JSON: ["a": ["hi", "invalid"]]))
            XCTAssertEqual(test.values.count, 1)
            XCTAssert(test.values.contains(.First))
        } catch let error {
            XCTFail("Expected no errors, got \(error)")
        }
    }

    func testArrayOfValuesInsertsDefault() {
        struct Test: Mappable {
            let values: [Value]
            init(map: Mapper) throws {
                self.values = try map.from("a", defaultValue: .First)
            }
        }

        enum Value: String {
            case First = "hi"
        }

        do {
            let test = try Test(map: Mapper(JSON: ["a": ["invalid"]]))
            XCTAssertEqual(test.values.count, 1)
            XCTAssert(test.values.contains(.First))
        } catch let error {
            XCTFail("Expected no errors, got \(error)")
        }
    }
}
