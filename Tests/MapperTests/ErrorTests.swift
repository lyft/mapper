import Mapper
import XCTest

final class ErrorTests: XCTestCase {
    func testTypeMismatch() {
        struct Test: Mappable {
            init(map: Mapper) throws {}
        }

        do {
            let map = Mapper(JSON: ["field": 1])
            let _: Test = try map.from("field")
            XCTFail("Should have thrown")
        } catch MapperError.typeMismatchError(let field, let value, let type) {
            XCTAssert(field == "field")
            XCTAssert(value as? Int == 1)
            XCTAssert(type == NSDictionary.self)
        } catch {
            XCTFail("Expected typeMismatchError")
        }
    }

    func testInvalidRawValue() {
        enum Suit: String {
            case spades = "spades"
        }

        do {
            let map = Mapper(JSON: ["suit": "hearts"])
            _ = try map.from("suit") as Suit
            XCTFail("Should have thrown")
        } catch MapperError.invalidRawValueError(let field, let value, let type) {
            XCTAssert(field == "suit")
            XCTAssert(value as? String == "hearts")
            XCTAssert(type == Suit.self)
        } catch {
            XCTFail("Expected invalidRawValueError")
        }
    }

    func testConvertibleError() {
        do {
            let map = Mapper(JSON: ["url": 1])
            let _: URL = try map.from("url")
            XCTFail("Should have thrown")
        } catch MapperError.convertibleError(let value, let type) {
            XCTAssert(value as? Int == 1)
            XCTAssert(type == String.self)
        } catch {
            XCTFail("Expected convertibleError")
        }
    }

    func testMissingField() {
        do {
            let map = Mapper(JSON: [:])
            let _: String = try map.from("string")
            XCTFail("Should have thrown")
        } catch MapperError.missingFieldError(let field) {
            XCTAssert(field == "string")
        } catch {
            XCTFail("Expected missingFieldError")
        }
    }

    func testCustomError() {
        do {
            let map = Mapper(JSON: ["string": "hi"])
            _ = try map.from("string", transformation: { _ in
                throw MapperError.customError(field: "string", message: "hi")
            })

            XCTFail("Should have thrown")
        } catch MapperError.customError(let field, let message) {
            XCTAssert(field == "string")
            XCTAssert(message == "hi")
        } catch {
            XCTFail("Expected customError")
        }
    }
}
