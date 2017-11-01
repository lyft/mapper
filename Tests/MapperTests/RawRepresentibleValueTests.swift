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
            case hearts = "hearts"
        }

        let test = try? Test(map: Mapper(JSON: ["suit": "hearts"]))
        XCTAssertTrue(test?.suit == .hearts)
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
            case first
        }

        let test = Test(map: Mapper(JSON: ["a": "nope", "b": "first"]))
        XCTAssertTrue(test.value == .first)
    }

    func testRawRepresentableArrayOfKeysReturningNil() {
        struct Test: Mappable {
            let value: Value?
            init(map: Mapper) {
                self.value = map.optionalFrom(["a", "b"])
            }
        }

        enum Value: String {
            case first
        }

        let test = Test(map: Mapper(JSON: [:]))
        XCTAssertNil(test.value)
    }

    func testRawRepresentibleArrayOfKeysDoesNotThrow() {
        struct Test: Mappable {
            let value: Value
            init(map: Mapper) throws {
                try self.value = map.from(["a", "b"])
            }
        }

        enum Value: String {
            case first
        }

        let test = try? Test(map: Mapper(JSON: ["a": 1, "b": "first"]))
        XCTAssertTrue(test?.value == .first)
    }

    func testRawRepresentibleArrayOfKeysThrowsWhenMissing() {
        struct Test: Mappable {
            let value: Value
            init(map: Mapper) throws {
                try self.value = map.from(["a", "b"])
            }
        }

        enum Value: String {
            case first
        }

        let test = try? Test(map: Mapper(JSON: ["a": 1, "b": 2]))
        XCTAssertNil(test)
    }

    func testArrayOfValuesWithMissingKey() {
        struct Test: Mappable {
            let value: [Value]
            init(map: Mapper) throws {
                self.value = try map.from("a")
            }
        }

        enum Value: String {
            case first
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
            case first
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
            case first
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
            case first
        }

        do {
            let test = try Test(map: Mapper(JSON: ["a": ["first", "invalid"]]))
            XCTAssertEqual(test.values.count, 1)
            XCTAssert(test.values.contains(.first))
        } catch let error {
            XCTFail("Expected no errors, got \(error)")
        }
    }

    func testArrayOfValuesInsertsDefault() {
        enum Value: String {
            case first
        }

        struct Test: Mappable {
            let values: [Value]
            init(map: Mapper) throws {
                self.values = try map.from("a", defaultValue: .first)
            }
        }

        do {
            let test = try Test(map: Mapper(JSON: ["a": ["invalid"]]))
            XCTAssertEqual(test.values.count, 1)
            XCTAssert(test.values.contains(.first))
        } catch let error {
            XCTFail("Expected no errors, got \(error)")
        }
    }

    func testOptionalArrayRawValues() {
        enum Value: String {
            case first
        }

        let map = Mapper(JSON: ["values": ["first", "there"]])
        let values: [Value]? = map.optionalFrom("values")
        XCTAssertEqual(values ?? [], [.first])
    }

    func testOptionalArrayRawValuesMissingKey() {
        enum Value: String {
            case first
        }

        let map = Mapper(JSON: [:])
        let values: [Value]? = map.optionalFrom("values")
        XCTAssertNil(values)
    }

    func testOptionalArrayDefaultValues() {
        enum Value: String {
            case first
        }

        let map = Mapper(JSON: ["values": ["invalid"]])
        let values: [Value]? = map.optionalFrom("values", defaultValue: .first)
        XCTAssertEqual(values ?? [], [.first])
    }
}
