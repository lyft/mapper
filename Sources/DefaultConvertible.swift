/// The DefaultConvertible protocol defines values that can be converted from JSON by conditionally
/// downcasting
///
/// This means any value that you could use with `as?`. If you have other types that would work to be casted
/// from JSON by just using `value as? YourType` you should conform to this protocol in order to get the
/// definition of that for free.
///
/// The reason this is a separate protocol instead of just using a protocol extension on Convertible is so
/// other consumers of Convertible will still get an error if they don't implement `fromMap`
public protocol DefaultConvertible: Convertible {}

extension DefaultConvertible {
    public static func fromMap(_ value: Any) throws -> ConvertedType {
        if let object = value as? ConvertedType {
            return object
        }

        throw MapperError.convertibleError(value: value, type: ConvertedType.self)
    }
}

/// The DefaultDoubleConvertible is used to allow converting from common JSON representations for a `double`
/// such as `"123.4"` or `123` which would otherwise fail to map from `Any` using the DefaultConvertible
/// protocol above.

public protocol DefaultDoubleConvertible: Convertible {}

extension DefaultDoubleConvertible {
    public static func fromMap(_ value: Any) throws -> Double {
        if let string = value as? String,
            let doubleValue = NumberFormatter().number(from: string)?.doubleValue {
            return doubleValue
        }

        if let intValue = value as? Int {
            return Double(intValue)
        }

        if let object = value as? Double {
            return object
        }

        throw MapperError.convertibleError(value: value, type: ConvertedType.self)
    }
}

// MARK: - Default Conformances

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
extension Float: DefaultConvertible {}
extension Double: DefaultDoubleConvertible {}
extension Bool: DefaultConvertible {}
