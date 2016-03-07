import Foundation

/**
 NSURL Convertible implementation

 This implementation assumes the given value is a string which can be used to create a NSURL
 if not a `MapperError` is thrown
 */
extension NSURL: Convertible {
    @warn_unused_result
    public static func fromMap(value: AnyObject?) throws -> NSURL {
        guard let string = value as? String, let URL = NSURL(string: string) else {
            throw MapperError()
        }

        return URL
    }
}
