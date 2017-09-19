/// The StringConvertible protocol defines values that can be converted from JSON by conditionally
/// downcasting or instantiating with a string
///
/// This means any value that you could use with `as?` or strings via init(). If you have other types 
/// that would work to be casted from JSON by just using `value as? YourType` or`YourType(stringValue)` 
/// you should conform to this protocol in order to get the definition of that for free.
public protocol StringConvertible: Convertible {
    init?(_ text: String)
}

extension StringConvertible {
    public static func fromMap(_ value: Any) throws -> ConvertedType {
        if let object = value as? ConvertedType {
            return object
        }
        if let text = value as? String, let object = Self(text) as? ConvertedType {
            return object
        }

        throw MapperError.convertibleError(value: value, type: ConvertedType.self)
    }
}

extension Int: StringConvertible {
    public init?(_ text: String) {
        self.init(text, radix: 10)
    }
}

extension UInt: StringConvertible {
    public init?(_ text: String) {
        self.init(text, radix: 10)
    }
}

extension Float: StringConvertible {}
extension Double: StringConvertible {}
extension Bool: StringConvertible {}
