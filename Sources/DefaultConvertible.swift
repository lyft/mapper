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
