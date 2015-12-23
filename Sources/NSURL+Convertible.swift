import Foundation

/**
 NSURL Convertible implementation

 This implementation assumes the given value is a string which can be used to create a NSURL
 if not a `MapperError` is thrown
 */
extension NSURL: Convertible {
    @warn_unused_result
    public static func fromMap(value: AnyObject?) throws -> NSURL {
        if let string = value as? String, let URL = NSURL(string: string) {
            return URL
        }

        throw MapperError()
    }
}
