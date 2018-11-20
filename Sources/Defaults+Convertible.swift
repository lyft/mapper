/// These Foundation conformances are acceptable since we already depend on Foundation. No other frameworks
/// Should be important as part of Mapper for default conformances. Consumers should conform any other common
/// Types in an extension in their own projects (e.g. `CGFloat`)
import Foundation
extension NSDictionary: DefaultConvertible {}
extension NSArray: DefaultConvertible {}

extension String: DefaultConvertible {}
extension Int: DefaultConvertible {}
extension Int32: DefaultConvertible {}
extension Int64: DefaultConvertible {}
extension UInt: DefaultConvertible {}
extension UInt32: DefaultConvertible {}
extension UInt64: DefaultConvertible {}
extension Double: DefaultConvertible {}
extension Bool: DefaultConvertible {}
