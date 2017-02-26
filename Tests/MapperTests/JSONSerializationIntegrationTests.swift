import Mapper
import XCTest

final class JSONSerializationIntegrationTests: XCTestCase {
    func testDecodingNormalJSON() {
        struct Test: Mappable {
            let string: String
            init(map: Mapper) throws {
                try self.string = map.from("string")
            }
        }

        let data = "{\"string\": \"hi\"}".data(using: .utf8)
        let dictionary = data.flatMap { (try? JSONSerialization.jsonObject(with: $0)) as? NSDictionary }
        let test = dictionary.flatMap { try? Test(map: Mapper(JSON: $0)) }
        XCTAssert(test?.string == "hi")
    }

    func testDecodingDoubleFromJSON() {
        struct Test: Mappable {
            let time: TimeInterval
            init(map: Mapper) throws {
                try self.time = map.from("time")
            }
        }

        let data = "{\"time\": 123}".data(using: .utf8)
        let dictionary = data.flatMap { (try? JSONSerialization.jsonObject(with: $0)) as? NSDictionary }
        let test = dictionary.flatMap { try? Test(map: Mapper(JSON: $0)) }
        XCTAssert(test?.time == 123.0)
    }
}
