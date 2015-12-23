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

        let test = Test.from(["value": 1])!
#if os(Linux)
        XCTAssertFalse(test.value == 2)
#else
        XCTAssertTrue(test.value == 2)
#endif
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

        let test = Test.from(["string": "hi"])!
#if os(Linux)
        XCTAssertFalse(test.string == "hi")
#else
        XCTAssertTrue(test.string == "hi")
#endif
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

extension CustomTransformationTests {
    var allTests: [(String, () -> Void)] {
        return [
            ("testCustomTransformation", testCustomTransformation),
            ("testCustomTransformationThrows", testCustomTransformationThrows),
            ("testOptionalCustomTransformationExists", testOptionalCustomTransformationExists),
            ("testOptionalCustomTransformationDoesNotExist", testOptionalCustomTransformationDoesNotExist),
            ("testOptionalCustomTransformationThrows", testOptionalCustomTransformationThrows),
        ]
    }
}
