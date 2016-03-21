import Foundation

/**
 Mapper creates strongly typed objects from a given NSDictionary based on the mapping provided by implementing
 the Mappable protocol (see `Mappable` for an example).
 */
public struct Mapper {
    private let JSON: NSDictionary

    /**
     Create a Mapper with a NSDictionary to use as source data

     - parameter JSON: The dictionary to use for the data
     */
    @warn_unused_result
    public init(JSON: NSDictionary) {
        self.JSON = JSON
    }

    // MARK: - T

    /**
     Get a typed value from the given key in the source data

     - parameter key: The key to retrieve from the source data, can be an empty string to return the entire
                      data set

     - throws: `MapperError` if the value for the given key doesn't exist or cannot be converted to T

     - returns: The value for the given key, if it can be converted to the expected type T
     */
    @warn_unused_result
    public func from<T>(field: String) throws -> T {
        if let value = self.JSONFromField(field) as? T {
            return value
        }

        throw MapperError()
    }

    /**
     Get an optional typed value from the given key in the source data

     - parameter key: The key to retrieve from the source data, can be an empty string to return the entire
                      data set

     - returns: The value for the given key, if it can be converted to the expected type T otherwise nil
     */
    @warn_unused_result
    public func optionalFrom<T>(field: String) -> T? {
        return try_(try self.from(field))
    }

    /**
     Get an optional value from the given keys and source data. This returns the first non-nil value produced
     in order based on the array of fields

     - parameter fields: The array of fields to check from the source data.

     - returns: The first non-nil value to be produced from the array of fields, or nil if none exist
    */
    @warn_unused_result
    public func optionalFrom<T>(fields: [String]) -> T? {
        for field in fields {
            if let value: T = try_(try self.from(field)) {
                return value
            }
        }

        return nil
    }

    // MARK: - T: RawRepresentable

    /**
     Get a RawRepresentable value from the given key in the source data

     This allows you to transparently create instances of enums and other RawRepresentables from source data

     - parameter key: The key to retrieve from the source data, can be an empty string to return the entire
                      data set

     - throws: `MapperError` if the value for the given key doesn't exist or cannot be converted to T

     - returns: The value for the given key, if it can be converted to the expected type T
     */
    @warn_unused_result
    public func from<T: RawRepresentable>(field: String) throws -> T {
        if let rawValue = self.JSONFromField(field) as? T.RawValue,
            let value = T(rawValue: rawValue)
        {
            return value
        }

        throw MapperError()
    }

    /**
     Get an optional RawRepresentable value from the given key in the source data

     This allows you to transparently create instances of enums and other RawRepresentables from source data

     - parameter key: The key to retrieve from the source data, can be an empty string to return the entire
                      data set

     - returns: The value for the given key, if it can be converted to the expected type T otherwise nil
     */
    @warn_unused_result
    public func optionalFrom<T: RawRepresentable>(field: String) -> T? {
        return try_(try self.from(field))
    }

    /**
     Get an optional value from the given keys and source data. This returns the first non-nil value produced
     in order based on the array of fields

     - parameter fields: The array of fields to check from the source data.

     - returns: The first non-nil value to be produced from the array of fields, or nil if none exist
    */
    @warn_unused_result
    public func optionalFrom<T: RawRepresentable>(fields: [String]) -> T? {
        for field in fields {
            if let value: T = try_(try self.from(field)) {
                return value
            }
        }

        return nil
    }

    // MARK: - T: Mappable

    /**
     Get a Mappable value from the given key in the source data

     This allows you to transparently have nested Mappable values

     - parameter key: The key to retrieve from the source data, can be an empty string to return the entire
                      data set

     - throws: `MapperError` if the value for the given key doesn't exist or cannot be converted to T

     - returns: The value for the given key, if it can be converted to the expected type T
     */
    @warn_unused_result
    public func from<T: Mappable>(field: String) throws -> T {
        if let JSON = self.JSONFromField(field) as? NSDictionary {
            return try T(map: Mapper(JSON: JSON))
        }

        throw MapperError()
    }

    /**
     Get an array of Mappable values from the given key in the source data

     This allows you to transparently have nested arrays of Mappable values

     Note: If any value in the array of NSDictionaries is invalid, this method throws

     - parameter key: The key to retrieve from the source data, can be an empty string to return the entire
                      data set

     - throws: `MapperError` if the value for the given key doesn't exist or cannot be converted to [T]
               this mean Mapper throws if the given value is also not an array of NSDictionaries

     - returns: The value for the given key, if it can be converted to the expected type [T]
     */
    @warn_unused_result
    public func from<T: Mappable>(field: String) throws -> [T] {
        if let JSON = self.JSONFromField(field) as? [NSDictionary] {
            return try JSON.map { try T(map: Mapper(JSON: $0)) }
        }

        throw MapperError()
    }

    /**
     Get an optional Mappable value from the given key in the source data

     This allows you to transparently have nested Mappable values

     - parameter key: The key to retrieve from the source data, can be an empty string to return the entire
                      data set

     - returns: The value for the given key, if it can be converted to the expected type T otherwise nil
     */
    @warn_unused_result
    public func optionalFrom<T: Mappable>(field: String) -> T? {
        return try_(try self.from(field))
    }

    /**
     Get an optional array of Mappable values from the given key in the source data

     This allows you to transparently have nested arrays of Mappable values

     Note: If any value in the provided array of NSDictionaries is invalid, this method returns nil

     - parameter key: The key to retrieve from the source data, can be an empty string to return the entire
                      data set

     - returns: The value for the given key, if it can be converted to the expected type [T]
     */
    @warn_unused_result
    public func optionalFrom<T: Mappable>(field: String) -> [T]? {
        return try_(try self.from(field))
    }

    /**
     Get an optional value from the given keys and source data. This returns the first non-nil value produced
     in order based on the array of fields

     - parameter fields: The array of fields to check from the source data.

     - returns: The first non-nil value to be produced from the array of fields, or nil if none exist
    */
    @warn_unused_result
    public func optionalFrom<T: Mappable>(fields: [String]) -> T? {
        for field in fields {
            if let value: T = try_(try self.from(field)) {
                return value
            }
        }

        return nil
    }

    // MARK: - T: Convertible

    /**
     Get a Convertible value from a field in the source data

     This transparently converts your types that conform to Convertible to properties on the Mappable type

     - parameter key: The key to retrieve from the source data, can be an empty string to return the entire
                      data set

     - throws: `MapperError` if the value for the given key doesn't exist or cannot be converted to T

     - returns: The value for the given key, if it can be converted to the expected type T
     */
    @warn_unused_result
    public func from<T: Convertible where T == T.ConvertedType>(field: String) throws -> T {
        return try self.from(field, transformation: T.fromMap)
    }

    /**
     Get an array of Convertible values from a field in the source data

     This transparently converts your types that conform to Convertible to an array on the Mappable type

     - parameter key: The key to retrieve from the source data, can be an empty string to return the entire
                      data set

     - throws: `MapperError` if the value for the given key doesn't exist or cannot be converted to [T]

     - returns: The value for the given key, if it can be converted to the expected type [T]
     */
    @warn_unused_result
    public func from<T: Convertible where T == T.ConvertedType>(field: String) throws -> [T] {
        if let JSON = self.JSONFromField(field) as? [AnyObject] {
            return try JSON.map(T.fromMap)
        }

        throw MapperError()
    }

    /**
     Get a Convertible value from a field in the source data

     This transparently converts your types that conform to Convertible to properties on the Mappable type

     - parameter key: The key to retrieve from the source data, can be an empty string to return the entire
                      data set

     - returns: The value for the given key, if it can be converted to the expected type T otherwise nil
     */
    @warn_unused_result
    public func optionalFrom<T: Convertible where T == T.ConvertedType>(field: String) -> T? {
        return try_(try self.from(field, transformation: T.fromMap))
    }

    /**
     Get an optional array of Convertible values from a field in the source data

     This transparently converts your types that conform to Convertible to an array on the Mappable type

     - parameter key: The key to retrieve from the source data, can be an empty string to return the entire
                      data set

     - returns: The value for the given key, if it can be converted to the expected type [T]
     */
    @warn_unused_result
    public func optionalFrom<T: Convertible where T == T.ConvertedType>(field: String) -> [T]? {
        return try_(try self.from(field))
    }

    /**
     Get an optional value from the given keys and source data. This returns the first non-nil value produced
     in order based on the array of fields

     - parameter fields: The array of fields to check from the source data.

     - returns: The first non-nil value to be produced from the array of fields, or nil if none exist
    */
    @warn_unused_result
    public func optionalFrom<T: Convertible where T == T.ConvertedType>(fields: [String]) -> T? {
        for field in fields {
            if let value: T = try_(try self.from(field)) {
                return value
            }
        }

        return nil
    }

    // MARK: - Custom Transformation

    /**
     Get a typed value from the given key by using the given transformation

     - parameter key:            The key to retrieve from the source data, can be an empty string to return
                                 the entire data set
     - parameter transformation: The transformation function used to create the expected value

     - throws: Any exception thrown by the transformation function, if you're implementing the transformation
               function you should use `MapperError`, see the documentation there for more info

     - returns: The value of type T for the given key, if the transformation function doesn't throw
     */
    @warn_unused_result
    public func from<T>(field: String, transformation: AnyObject? throws -> T) rethrows -> T {
        return try transformation(self.JSONFromField(field))
    }

    /**
     Get an optional typed value from the given key by using the given transformation

     - parameter key:            The key to retrieve from the source data, can be an empty string to return
                                 the entire data set
     - parameter transformation: The transformation function used to create the expected value

     - returns: The value of type T for the given key, if the transformation function doesn't throw otherwise
                nil
     */
    @warn_unused_result
    public func optionalFrom<T>(field: String, transformation: AnyObject? throws -> T?) -> T? {
        return try_(try transformation(self.JSONFromField(field))).flatMap { $0 }
    }

    // MARK: - Private

    /**
     Get the AnyObject? for a given key. If an empty string is passed, return the entire data source. This
     allows users to create objects from multiple fields in the top level of the data source

     - parameter field: The key to extract from the data source, can be an empty string to return the entire
                        data source

     - returns: The object for the given key
     */
    private func JSONFromField(field: String) -> AnyObject? {
        return field.isEmpty ? self.JSON : self.JSON.valueForKeyPath(field)
    }
}

/**
 This is our custom implementation of `try?` until the memory leak in Swift itself is fixed

 - parameter closure: The throwing closure to execute

 - returns: The value returned from executing the closure, or nil if it threw
 */
internal func try_<T>(@autoclosure closure: () throws -> T) -> T? {
    do {
        return try closure()
    } catch {
        return nil
    }
}
