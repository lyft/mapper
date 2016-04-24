import Mapper
import XCTest

final class ErrorTests: XCTestCase {
    func testTypeMismatch() {
        do {
            let map = Mapper(JSON: ["field": 1])
            let _: String = try map.from("field")
            XCTFail()
        } catch MapperError.TypeMismatchError(let field, let value, let type) {
            XCTAssert(field == "field")
            XCTAssert(value as? Int == 1)
            XCTAssert(type == String.self)
        } catch {
            XCTFail()
        }
    }

    func testInvalidRawValue() {
        enum Suit: String {
            case Spades = "spades"
        }

        do {
            let map = Mapper(JSON: ["suit": "hearts"])
            let _: Suit = try map.from("suit")
            XCTFail()
        } catch MapperError.InvalidRawValueError(let field, let value, let type) {
            XCTAssert(field == "suit")
            XCTAssert(value as? String == "hearts")
            XCTAssert(type == Suit.self)
        } catch {
            XCTFail()
        }
    }

    func testConvertibleError() {
        do {
            let map = Mapper(JSON: ["url": 1])
            let _: NSURL = try map.from("url")
            XCTFail()
        } catch MapperError.ConvertibleError(let value, let type) {
            XCTAssert(value as? Int == 1)
            XCTAssert(type == String.self)
        } catch {
            XCTFail()
        }
    }

    func testMissingField() {
        do {
            let map = Mapper(JSON: [:])
            let _: String = try map.from("string")
            XCTFail()
        } catch MapperError.MissingFieldError(let field) {
            XCTAssert(field == "string")
        } catch {
            XCTFail()
        }
    }

    func testCustomError() {
        do {
            let map = Mapper(JSON: [:])
            _ = try map.from("string", transformation: { _ in
                throw MapperError.CustomError(field: "string", message: "hi")
            })

            XCTFail()
        } catch MapperError.CustomError(let field, let message) {
            XCTAssert(field == "string")
            XCTAssert(message == "hi")
        } catch {
            XCTFail()
        }
    }

    func testDeprecatedInitializer() {
        do {
            let map = Mapper(JSON: [:])
            _ = try map.from("string", transformation: { _ in throw MapperError() })
            XCTFail()
        } catch MapperError.CustomError(let field, let message) {
            XCTAssertNil(field)
            XCTAssertFalse(message.isEmpty)
        } catch {
            XCTFail()
        }
    }
}
