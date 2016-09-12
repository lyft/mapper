import Foundation

/**
 URL Convertible implementation
 */
extension URL: Convertible {
    /**
     Create a URL from Mapper

     - parameter value: The object (or nil) passed from Mapper

     - throws: MapperError.convertibleError if the passed value is not a String
     - throws: MapperError.customError      if the passed value a String but the URL initializer returns nil

     - returns: The created URL
     */
    public static func fromMap(_ value: Any) throws -> URL {
        guard let string = value as? String else {
            throw MapperError.convertibleError(value: value, type: String.self)
        }

        if let URL = URL(string: string) {
            return URL
        }

        throw MapperError.customError(field: nil, message: "'\(string)' is not a valid URL")
    }
}
