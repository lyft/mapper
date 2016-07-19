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
            XCTFail()
        } catch MapperError.typeMismatchError(let field, let value, let type) {
            XCTAssert(field == "field")
            XCTAssert(value as? Int == 1)
            XCTAssert(type == NSDictionary.self)
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
        } catch MapperError.invalidRawValueError(let field, let value, let type) {
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
            let _: URL = try map.from("url")
            XCTFail()
        } catch MapperError.convertibleError(let value, let type) {
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
        } catch MapperError.missingFieldError(let field) {
            XCTAssert(field == "string")
        } catch {
            XCTFail()
        }
    }

    func testCustomError() {
        do {
            let map = Mapper(JSON: ["string": "hi"])
            _ = try map.from("string", transformation: { _ in
                throw MapperError.customError(field: "string", message: "hi")
            })

            XCTFail()
        } catch MapperError.customError(let field, let message) {
            XCTAssert(field == "string")
            XCTAssert(message == "hi")
        } catch {
            XCTFail()
        }
    }
}
