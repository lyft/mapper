import Foundation

/**
 NSURL Convertible implementation
 */
extension NSURL: Convertible {
    /**
     Create a NSURL from Mapper

     - parameter value: The object (or nil) passed from Mapper

     - throws: MapperError.ConvertibleError if the passed value is not a String
     - throws: MapperError.CustomError      if the passed value a String but the NSURL initializer returns nil

     - returns: The created NSURL
     */
    @warn_unused_result
    public static func fromMap(value: AnyObject?) throws -> NSURL {
        guard let string = value as? String else {
            throw MapperError.ConvertibleError(value: value, type: String.self)
        }

        if let URL = NSURL(string: string) {
            return URL
        }

        throw MapperError.CustomError(field: nil, message: "'\(string)' is not a valid NSURL")
    }
}
