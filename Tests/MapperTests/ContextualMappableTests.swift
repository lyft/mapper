import Mapper
import XCTest

private enum Currency {
    case USD
    case GBP
    case EUR
}

private struct Price: ContextualMappable {
    typealias Context = Currency
    let valueInCurrency: Double
    init(map: Mapper, context: Currency) throws {
        let cents: Double = try map.from("value")
        switch context {
        case .USD:
            self.valueInCurrency = cents
        case .GBP:
            self.valueInCurrency = cents * 1.5
        case .EUR:
            self.valueInCurrency = cents * 1.2
        }
    }
}

final class ContextualMappableTests: XCTestCase {
    func testContextualMappable() {
        let test = try? Price(map: Mapper(JSON: ["value": 1000.0]), context: .EUR)
        XCTAssertTrue(test?.valueInCurrency == 1200.0)
    }
}
