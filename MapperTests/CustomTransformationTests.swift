import Mapper
import XCTest

final class CustomTransformationTests: XCTestCase {
    func testCustomTransformation() {
        struct Test: Mappable {
            let value: Int
            init(map: Mapper) throws {
                value = map.from("value", transformation: { thing in
                    if let a = thing as? Int {
                        return a + 1
                    } else {
                        return 0
                    }
                })
            }
        }

        let test = try! Test(map: Mapper(JSON: ["value": 1]))
        XCTAssertTrue(test.value == 2)
    }

    func testCustomTransformationThrows() {
        struct Test: Mappable {
            let value: Int
            init(map: Mapper) throws {
                try value = map.from("foo", transformation: { object in
                    throw MapperError()
                })
            }
        }

        let test = try? Test(map: Mapper(JSON: [:]))
        XCTAssertNil(test)
    }

    func testOptionalCustomTransformationExists() {
        struct Test: Mappable {
            let string: String?
            init(map: Mapper) throws {
                string = map.optionalFrom("string", transformation: { $0 as? String })
            }
        }

        let test = try! Test(map: Mapper(JSON: ["string": "hi"]))
        XCTAssertTrue(test.string == "hi")
    }

    func testOptionalCustomTransformationDoesNotExist() {
        struct Test: Mappable {
            let string: String?
            init(map: Mapper) throws {
                string = map.optionalFrom("string", transformation: { $0 as? String })
            }
        }

        let test = try! Test(map: Mapper(JSON: [:]))
        XCTAssertNil(test.string)
    }

    func testOptionalCustomTransformationThrows() {
        struct Test: Mappable {
            let string: String?
            init(map: Mapper) throws {
                string = map.optionalFrom("foo", transformation: { _ in throw MapperError() })
            }
        }

        let test = try! Test(map: Mapper(JSON: [:]))
        XCTAssertNil(test.string)
    }
}
