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

        let test = try! Test(map: Mapper(JSON: ["suit": "hearts"]))
        XCTAssertTrue(test.suit == .Hearts)
    }

    func testRawRepresentableNumber() {
        struct Test: Mappable {
            let value: Value
            init(map: Mapper) throws {
                try self.value = map.from("value")
            }
        }

        enum Value: Int {
            case First = 1
        }

        let test = try! Test(map: Mapper(JSON: ["value": 1]))
        XCTAssertTrue(test.value == .First)
    }

    func testMissingRawRepresentableNumber() {
        struct Test: Mappable {
            let value: Value
            init(map: Mapper) throws {
                try self.value = map.from("value")
            }
        }

        enum Value: Int {
            case First = 1
        }

        let test = try? Test(map: Mapper(JSON: [:]))
        XCTAssertNil(test)
    }

    func testOptionalRawRepresentable() {
        struct Test: Mappable {
            let value: Value?
            init(map: Mapper) throws {
                self.value = map.optionalFrom("value")
            }
        }

        enum Value: Int {
            case First = 1
        }

        let test = try! Test(map: Mapper(JSON: [:]))
        XCTAssertNil(test.value)
    }

    func testExistingOptionalRawRepresentable() {
        struct Test: Mappable {
            let value: Value?
            init(map: Mapper) throws {
                self.value = map.optionalFrom("value")
            }
        }

        enum Value: Int {
            case First = 1
        }

        let test = try! Test(map: Mapper(JSON: ["value": 1]))
        XCTAssertTrue(test.value == .First)
    }

    func testRawRepresentableTypeMismatch() {
        struct Test: Mappable {
            let value: Value?
            init(map: Mapper) throws {
                self.value = map.optionalFrom("value")
            }
        }

        enum Value: Int {
            case First = 1
        }

        let test = try! Test(map: Mapper(JSON: ["value": "not an int"]))
        XCTAssertNil(test.value)
    }

    func testRawRepresentableArrayOfKeys() {
        struct Test: Mappable {
            let value: Value?
            init(map: Mapper) throws {
                self.value = map.optionalFrom(["a", "b"])
            }
        }

        enum Value: String {
            case First = "hi"
        }

        let test = try! Test(map: Mapper(JSON: ["a": "nope", "b": "hi"]))
        XCTAssertTrue(test.value == .First)
    }

    func testRawRepresentableArrayOfKeysReturningNil() {
        struct Test: Mappable {
            let value: Value?
            init(map: Mapper) throws {
                self.value = map.optionalFrom(["a", "b"])
            }
        }

        enum Value: String {
            case First = "hi"
        }

        let test = try! Test(map: Mapper(JSON: [:]))
        XCTAssertNil(test.value)
    }

    func testRawRepresentableArray() {
        struct Test: Mappable {
            let values: [Value]
            init(map: Mapper) throws {
                self.values = try map.from("values").flatMap { $0 }
            }
        }
        enum Value: String {
            case ValueA = "a"
            case ValueB = "b"
            case ValueC = "c"
        }
        let json: NSDictionary = ["values": ["a", "b", "c", "a"]]

        do {
            let test = try Test(map: Mapper(JSON: json))
            XCTAssert(test.values[0] == Value.ValueA)
            XCTAssert(test.values[1] == Value.ValueB)
            XCTAssert(test.values[2] == Value.ValueC)
            XCTAssert(test.values[3] == Value.ValueA)
        } catch {
            XCTFail("Expecting success")
        }
    }

    func testRawRepresentableInvalidKey() {
        struct Test: Mappable {
            let values: [Value]
            init(map: Mapper) throws {
                self.values = try map.from("values").flatMap { $0 }
            }
        }
        enum Value: String {
            case ValueA = "a"
            case ValueB = "b"
            case ValueC = "c"
        }
        let json: NSDictionary = ["invalid": ["a", "b", "c", "a"]]

        do {
            let _ = try Test(map: Mapper(JSON: json))
            XCTFail("Expecting Failure")
        } catch { }
    }

    func testRawRepresentableArrayWithInvalidElements() {
        struct Test: Mappable {
            let values: [Value]
            init(map: Mapper) throws {
                self.values = try map.from("values").flatMap { $0 }
            }
        }
        enum Value: String {
            case ValueA = "a"
            case ValueB = "b"
            case ValueC = "c"
        }
        let json: NSDictionary = ["values": ["a", "b", 1, "a", "z"]]

        do {
            let test = try Test(map: Mapper(JSON: json))
            XCTAssert(test.values.count == 3)
            XCTAssert(test.values[0] == Value.ValueA)
            XCTAssert(test.values[1] == Value.ValueB)
            XCTAssert(test.values[2] == Value.ValueA)
        } catch {
            XCTFail("Expecting success")
        }
    }
}
