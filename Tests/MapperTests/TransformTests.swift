import Mapper
import XCTest

private struct Example: Mappable, Equatable {
    let key: String
    let value: Int

    init(key: String, value: Int) {
        self.key = key
        self.value = value
    }

    init(map: Mapper) throws {
        try key = map.from("string")
        try value = map.from("value")
    }
}

private func == (lhs: Example, rhs: Example) -> Bool {
    return lhs.key == rhs.key && lhs.value == rhs.value
}

final class TransformTests: XCTestCase {
    func testToDictionary() {
        struct Test: Mappable {
            let dictionary: [String: Example]

            init(map: Mapper) throws {
                try dictionary = map.from("examples",
                    transformation: Transform.toDictionary(key: { $0.key }))
            }
        }

        let JSON: NSDictionary = [
            "examples": [
                [
                    "string": "hi",
                    "value": 1,
                ],
                [
                    "string": "bye",
                    "value": 2,
                ],
            ],
        ]

        let test = Test.from(JSON)
        XCTAssertTrue(test?.dictionary.count == 2)
        XCTAssertTrue(test?.dictionary["hi"] == Example(key: "hi", value: 1))
        XCTAssertTrue(test?.dictionary["bye"] == Example(key: "bye", value: 2))
    }

    func testToDictionaryInvalid() {
        struct Test: Mappable {
            let dictionary: [String: Example]

            init(map: Mapper) throws {
                try dictionary = map.from("examples",
                    transformation: Transform.toDictionary(key: { $0.key }))
            }
        }

        do {
            _ = try Test(map: Mapper(JSON: ["examples": 1]))
            XCTFail("Should have thrown")
        } catch MapperError.convertibleError(let value, let type) {
            XCTAssert(value as? Int == 1)
            XCTAssert(type == [NSDictionary].self)
        } catch {
            XCTFail("Expected convertibleError")
        }
    }

    func testToDictionaryOneInvalid() {
        struct Test: Mappable {
            let dictionary: [String: Example]

            init(map: Mapper) throws {
                try dictionary = map.from("examples",
                    transformation: Transform.toDictionary(key: { $0.key }))
            }
        }

        let JSON: NSDictionary = [
            "examples": [
                [
                    "string": "hi",
                    "value": 1,
                ],
                [
                    "string": "bye",
                ],
            ],
        ]

        let test = try? Test(map: Mapper(JSON: JSON))
        XCTAssertNil(test)
    }

    func testMissingFieldErrorFromTransformation() {
        do {
            let map = Mapper(JSON: [:])
            let _: String = try map.from("foo", transformation: { _ in return "hi" })
            XCTFail("Should have thrown")
        } catch MapperError.missingFieldError(let field) {
            XCTAssert(field == "foo")
        } catch {
            XCTFail("Expected missingFieldError")
        }
    }
}
