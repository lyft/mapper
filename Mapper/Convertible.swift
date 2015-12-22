/**
 The Convertible protocol defines how to convert values to custom objects
 this differs from the Mappable protocol because the creation function is passed
 an AnyObject, allowing your definition to accept any data, and convert it as seen fit

 NSURL's Convertible implementation is provided by default, assuming the passed value
 is a String

 Example:

 // Convertible implementation for custom logic to create `CLLocationCoordinate2D`s from dictionaries
 extension CLLocationCoordinate2D: Convertible {
     public static func fromMap(value: AnyObject?) throws -> CLLocationCoordinate2D {
         guard let location = value as? NSDictionary,
             let latitude = (location["lat"] ?? location["latitude"]) as? Double,
             let longitude = (location["lng"] ?? location["longitude"]) as? Double else
         {
             throw MapperError()
         }

         return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
     }
 }
 */
public protocol Convertible {
    /// This typealias allows us to enforce the returned value is of type Self, without requiring
    /// implementations to return a value using `self.init`
    typealias ConvertedType = Self

    /**
     `fromMap` returns the expected value based off the provided input, this allows you to attempt
     to cast the value to anything you'd like, and perform any manipulation on it (don't use this as a
     conversion mechanism, instead see Transform)

     - parameter value: Any value (probably from the data source's value for the given key) to create
                        the expected object with

     - throws: Any error from your custom implementation, `MapperError` is recommended

     - returns: The successfully created value from the given input
     */
    @warn_unused_result
    static func fromMap(value: AnyObject?) throws -> ConvertedType
}
