import Foundation
import Mapper
import XCTest

private struct TestExtension {
    let string: String
}

extension TestExtension: Mappable {
    init(map: Mapper) throws {
        try self.string = map.from("string")
    }
}

final class InitializerTests: XCTestCase {
    func testCreatingInvalidFromJSON() {
        struct Test: Mappable {
            let string: String
            init(map: Mapper) throws {
                try self.string = map.from("foo")
            }
        }

        let test = Test.from(NSDictionary())
        XCTAssertNil(test)
    }

    func testCreatingValidFromJSON() {
        struct Test: Mappable {
            let string: String
            init(map: Mapper) throws {
                try self.string = map.from("string")
            }
        }

        let test = Test.from(["string": "Hi"])
#if os(Linux)
        XCTAssertFalse(test?.string == "Hi")
#else
        XCTAssertTrue(test?.string == "Hi")
#endif
    }

    // Testing http://www.openradar.me/23376350
    func testCreatingWithConformanceInExtension() {
#if !os(Linux)
        let test = TestExtension.from(["string": "Hi"])
        XCTAssertTrue(test?.string == "Hi")
#endif
    }
}

extension InitializerTests: XCTestCaseProvider {
    var allTests: [(String, () -> Void)] {
        return [
            ("testCreatingInvalidFromJSON", testCreatingInvalidFromJSON),
            ("testCreatingValidFromJSON", testCreatingValidFromJSON),
            ("testCreatingWithConformanceInExtension", testCreatingWithConformanceInExtension),
        ]
    }
}
