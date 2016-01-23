import Foundation

/**
 The Mappable protocol defines how to create a custom object from a Mapper

 Example:

 public struct Thing: Mappable {
    let string: String
    let URL: NSURL?

    public init(map: Mapper) throws {
        // Attemps to convert the value for the "some_string" key to a String, if it fails
        // it throws an error
        try string = map.from("some_string")

        // Attemps to convert the value for the "base_url" key to an NSURL, if it fails
        // it assigns URL to nil
        URL = map.optionalFrom("base_url")
    }
 }
 */
public protocol Mappable {
    /**
     Define how your custom object is created from a Mapper object
     */
    @warn_unused_result
    init(map: Mapper) throws

    /**
     Convenience method for creating Mappable objects from NSDictionaries

     - parameter JSON: The JSON to create the object from

     - returns: The object if it could be created, nil if creating the object threw an error
     */
    @warn_unused_result
    static func from(JSON: NSDictionary) -> Self?

    /**
     Convenience method for creating Mappable objects from a NSArray

     - parameter JSON: The JSON to create the objects from

     - returns: An array of the created objects, or nil if creating threw
     */
    @warn_unused_result
    static func from(JSON: NSArray) -> [Self]?
}

public extension Mappable {
    @warn_unused_result
    public static func from(JSON: NSDictionary) -> Self? {
        return try? self.init(map: Mapper(JSON: JSON))
    }

    @warn_unused_result
    public static func from(JSON: NSArray) -> [Self]? {
        if let array = JSON as? [NSDictionary] {
            return try? array.map { try self.init(map: Mapper(JSON: $0)) }
        }

        return nil
    }
}
