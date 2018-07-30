import Foundation

// Float convertible implementation
extension Float: Convertible {
    public static func fromMap(_ value: Any) throws -> Float {
        if let value = value as? Float {
            return value
        }

        if let object = value as? NSNumber {
            return object.floatValue
        }

        throw MapperError.convertibleError(value: value, type: Float.self)
    }
}
