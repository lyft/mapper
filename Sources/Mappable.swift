import Foundation

/// The Mappable protocol defines how to create a custom object from a Mapper
///
/// Example:
///
/// ```
/// public struct Thing: Mappable {
///    let string: String
///    let URL: URL?
///
///    public init(map: Mapper) throws {
///        // Attemps to convert the value for the "some_string" key to a String, if it fails
///        // it throws an error
///        try string = map.from("some_string")
///
///        // Attemps to convert the value for the "base_url" key to an URL, if it fails
///        // it assigns URL to nil
///        URL = map.optionalFrom("base_url")
///    }
/// }
/// ```
public protocol Mappable {
    /// Define how your custom object is created from a Mapper object
    init(map: Mapper) throws
}

extension Mappable {
    /// Convenience method for creating Mappable objects from Dictionaries
    ///
    /// - parameter JSON: The JSON to create the object from
    ///
    /// - returns: The object if it could be created, nil if creating the object threw an error
    public static func from(_ JSON: [AnyHashable: Any]) -> Self? {
        return try? self.init(map: Mapper(JSON: JSON))
    }

    /// Convenience method for creating Mappable objects from an Array
    ///
    /// - parameter JSON: The JSON to create the objects from
    ///
    /// - returns: An array of the created objects, or nil if creating threw
    public static func from(_ JSON: [Any]) -> [Self]? {
        if let array = JSON as? [[AnyHashable: Any]] {
            return try? array.map { try self.init(map: Mapper(JSON: $0)) }
        }

        return nil
    }
}
