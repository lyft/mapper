import Mapper
import XCTest

final class CustomTransformationTests: XCTestCase {
    func testCustomTransformation() {
        struct Test: Mappable {
            let value: Int
            init(map: Mapper) throws {
                value = try map.from("value", transformation: { thing in
                    if let thing = thing as? Int {
                        return thing + 1
                    } else {
                        return 0
                    }
                })
            }
        }

        let test = try? Test(map: Mapper(JSON: ["value": 1]))
        XCTAssertTrue(test?.value == 2)
    }

    func testCustomTransformationThrows() {
        struct Test: Mappable {
            let value: Int
            init(map: Mapper) throws {
                try value = map.from("foo", transformation: { _ in
                    throw MapperError.customError(field: nil, message: "")
                })
            }
        }

        let test = try? Test(map: Mapper(JSON: [:]))
        XCTAssertNil(test)
    }

    func testOptionalCustomTransformationExists() {
        struct Test: Mappable {
            let string: String?
            init(map: Mapper) {
                string = map.optionalFrom("string", transformation: { $0 as? String })
            }
        }

        let test = Test(map: Mapper(JSON: ["string": "hi"]))
        XCTAssertTrue(test.string == "hi")
    }

    func testOptionalCustomTransformationDoesNotExist() {
        struct Test: Mappable {
            let string: String?
            init(map: Mapper) {
                string = map.optionalFrom("string", transformation: { $0 as? String })
            }
        }

        let test = Test(map: Mapper(JSON: [:]))
        XCTAssertNil(test.string)
    }

    func testOptionalCustomTransformationThrows() {
        struct Test: Mappable {
            let string: String?
            init(map: Mapper) throws {
                string = map.optionalFrom("foo", transformation: { _ in
                    throw MapperError.customError(field: nil, message: "")
                })
            }
        }

        do {
            let test = try Test(map: Mapper(JSON: [:]))
            XCTAssertNil(test.string)
        } catch {
            XCTFail("Shouldn't have failed to create Test")
        }
    }

    func testCustomTransformationArrayOfKeys() {
        struct Test: Mappable {
            let value: Int
            init(map: Mapper) throws {
                value = try map.from(["a", "b"], transformation: { thing in
                    if let thing = thing as? Int {
                        return thing + 1
                    }
                    throw MapperError.customError(field: nil, message: "")
                })
            }
        }

        do {
            let test = try Test(map: Mapper(JSON: ["a": "##", "b": 1]))
            XCTAssertEqual(test.value, 2)
        } catch {
            XCTFail("Shouldn't have failed to create Test")
        }
    }

    func testCustomTransformationArrayOfKeysThrows() {
        struct Test: Mappable {
            let value: Int
            init(map: Mapper) throws {
                value = try map.from(["a", "b"], transformation: { _ in
                    throw MapperError.customError(field: nil, message: "")
                })
            }
        }

        let test = try? Test(map: Mapper(JSON: ["a": "##", "b": 1]))
        XCTAssertNil(test)
    }

    func testOptionalCustomTransformationEmptyThrows() {
        struct Test: Mappable {
            let value: Int
            init(map: Mapper) throws {
                value = try map.from(["a", "b"], transformation: { thing in
                    if let thing = thing as? Int {
                        return thing + 1
                    }
                    throw MapperError.customError(field: nil, message: "")
                })
            }
        }

        let test = try? Test(map: Mapper(JSON: [:]))
        XCTAssertNil(test)
    }

    func testOptionalCustomTransformationArrayOfKeys() {
        struct Test: Mappable {
            let value: Int?
            init(map: Mapper) throws {
                value = map.optionalFrom(["a", "b"], transformation: { thing in
                    if let thing = thing as? Int {
                        return thing + 1
                    }
                    throw MapperError.customError(field: nil, message: "")
                })
            }
        }

        do {
            let test = try Test(map: Mapper(JSON: ["a": "##", "b": 1]))
            XCTAssertEqual(test.value, 2)
        } catch {
            XCTFail("Shouldn't have failed to create Test")
        }
    }

    func testOptionalCustomTransformationArrayOfKeysFails() {
        struct Test: Mappable {
            let value: Int?
            init(map: Mapper) throws {
                value = map.optionalFrom(["a", "b"], transformation: { _ in
                    throw MapperError.customError(field: nil, message: "")
                })
            }
        }

        do {
            let test = try Test(map: Mapper(JSON: ["a": "##", "b": 1]))
            XCTAssertNil(test.value)
        } catch {
            XCTFail("Shouldn't have failed to create Test")
        }
    }

    func testOptionalCustomTransformationArrayOfKeysReturnsNil() {
        struct Test: Mappable {
            let value: Int?
            init(map: Mapper) throws {
                value = map.optionalFrom(["a", "b"], transformation: { thing in
                    if let thing = thing as? Int {
                        return thing + 1
                    }
                    throw MapperError.customError(field: nil, message: "")
                })
            }
        }

        do {
            let test = try Test(map: Mapper(JSON: [:]))
            XCTAssertNil(test.value)
        } catch {
            XCTFail("Shouldn't have failed to create Test")
        }
    }
}
