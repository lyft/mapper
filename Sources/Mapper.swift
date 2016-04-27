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
     Get a typed value from the given field in the source data

     - parameter field: The field to retrieve from the source data, can be an empty string to return the
                        entire data set

     - throws: MapperError.MissingFieldError if the field doesn't exist
     - throws: MapperError.TypeMismatchError if the value exists with the incorrect type

     - returns: The value for the given field, if it can be converted to the expected type T
     */
    @warn_unused_result
    public func from<T>(field: String) throws -> T {
        let value = try self.JSONFromField(field)
        if let value = value as? T {
            return value
        }

        throw MapperError.TypeMismatchError(field: field, value: value, type: T.self)
    }

    /**
     Get an optional typed value from the given field in the source data

     - parameter field: The field to retrieve from the source data, can be an empty string to return the
                        entire data set

     - returns: The value for the given field, if it can be converted to the expected type T otherwise nil
     */
    @warn_unused_result
    public func optionalFrom<T>(field: String) -> T? {
        return try? self.from(field)
    }

    /**
     Get an optional value from the given fields and source data. This returns the first non-nil value
     produced in order based on the array of fields

     - parameter fields: The array of fields to check from the source data.

     - returns: The first non-nil value to be produced from the array of fields, or nil if none exist
    */
    @warn_unused_result
    public func optionalFrom<T>(fields: [String]) -> T? {
        for field in fields {
            if let value: T = try? self.from(field) {
                return value
            }
        }

        return nil
    }

    // MARK: - T: RawRepresentable

    /**
     Get a RawRepresentable value from the given field in the source data

     This allows you to transparently create instances of enums and other RawRepresentables from source data

     - parameter field: The field to retrieve from the source data, can be an empty string to return the
                        entire data set

     - throws: MapperError.MissingFieldError    if the field doesn't exist
     - throws: MapperError.TypeMismatchError    if the value exists but doesn't match the type of the RawValue
     - throws: MapperError.InvalidRawValueError if the value exists with the correct type, but the type's
                                                initializer fails with the passed rawValue

     - returns: The value for the given field, if it can be converted to the expected type T
     */
    @warn_unused_result
    public func from<T: RawRepresentable>(field: String) throws -> T {
        let object = try self.JSONFromField(field)
        guard let rawValue = object as? T.RawValue else {
            throw MapperError.TypeMismatchError(field: field, value: object, type: T.RawValue.self)
        }

        guard let value = T(rawValue: rawValue) else {
            throw MapperError.InvalidRawValueError(field: field, value: rawValue, type: T.self)
        }

        return value
    }

    /**
     Get an optional RawRepresentable value from the given field in the source data

     This allows you to transparently create instances of enums and other RawRepresentables from source data

     - parameter field: The field to retrieve from the source data, can be an empty string to return the
                        entire data set

     - returns: The value for the given field, if it can be converted to the expected type T otherwise nil
     */
    @warn_unused_result
    public func optionalFrom<T: RawRepresentable>(field: String) -> T? {
        return try? self.from(field)
    }

    /**
     Get an optional value from the given fields and source data. This returns the first non-nil value
     produced in order based on the array of fields

     - parameter fields: The array of fields to check from the source data.

     - returns: The first non-nil value to be produced from the array of fields, or nil if none exist
     */
    @warn_unused_result
    public func optionalFrom<T: RawRepresentable>(fields: [String]) -> T? {
        for field in fields {
            if let value: T = try? self.from(field) {
                return value
            }
        }

        return nil
    }

    // MARK: - T: Mappable

    /**
     Get a Mappable value from the given field in the source data

     This allows you to transparently have nested Mappable values

     - parameter field: The field to retrieve from the source data, can be an empty string to return the
                        entire data set

     - throws: MapperError.MissingFieldError if the field doesn't exist
     - throws: MapperError.TypeMismatchError if the field exists but isn't an NSDictionary

     - returns: The value for the given field, if it can be converted to the expected type T
     */
    @warn_unused_result
    public func from<T: Mappable>(field: String) throws -> T {
        let value = try self.JSONFromField(field)
        if let JSON = value as? NSDictionary {
            return try T(map: Mapper(JSON: JSON))
        }

        throw MapperError.TypeMismatchError(field: field, value: value, type: NSDictionary.self)
    }

    /**
     Get an array of Mappable values from the given field in the source data

     This allows you to transparently have nested arrays of Mappable values

     Note: If any value in the array of NSDictionaries is invalid, this method throws

     - parameter field: The field to retrieve from the source data, can be an empty string to return the
                        entire data set

     - throws: MapperError.MissingFieldError if the field doesn't exist
     - throws: MapperError.TypeMismatchError if the field exists but isn't an array of NSDictionarys
     - throws: Any errors produced by the subsequent Mappable initializers

     - returns: The value for the given field, if it can be converted to the expected type [T]
     */
    @warn_unused_result
    public func from<T: Mappable>(field: String) throws -> [T] {
        let value = try self.JSONFromField(field)
        if let JSON = value as? [NSDictionary] {
            return try JSON.map { try T(map: Mapper(JSON: $0)) }
        }

        throw MapperError.TypeMismatchError(field: field, value: value, type: [NSDictionary].self)
    }

    /**
     Get an optional Mappable value from the given field in the source data

     This allows you to transparently have nested Mappable values

     - parameter field: The field to retrieve from the source data, can be an empty string to return the
                        entire data set

     - returns: The value for the given field, if it can be converted to the expected type T otherwise nil
     */
    @warn_unused_result
    public func optionalFrom<T: Mappable>(field: String) -> T? {
        return try? self.from(field)
    }

    /**
     Get an optional array of Mappable values from the given field in the source data

     This allows you to transparently have nested arrays of Mappable values

     Note: If any value in the provided array of NSDictionaries is invalid, this method returns nil

     - parameter field: The field to retrieve from the source data, can be an empty string to return the
                        entire data set

     - returns: The value for the given field, if it can be converted to the expected type [T]
     */
    @warn_unused_result
    public func optionalFrom<T: Mappable>(field: String) -> [T]? {
        return try? self.from(field)
    }

    /**
     Get an optional value from the given fields and source data. This returns the first non-nil value
     produced in order based on the array of fields

     - parameter fields: The array of fields to check from the source data.

     - returns: The first non-nil value to be produced from the array of fields, or nil if none exist
     */
    @warn_unused_result
    public func optionalFrom<T: Mappable>(fields: [String]) -> T? {
        for field in fields {
            if let value: T = try? self.from(field) {
                return value
            }
        }

        return nil
    }

    // MARK: - T: Convertible

    /**
     Get a Convertible value from a field in the source data

     This transparently converts your types that conform to Convertible to properties on the Mappable type

     - parameter field: The field to retrieve from the source data, can be an empty string to return the
                        entire data set

     - throws: Any error produced by the custom Convertible implementation

     - returns: The value for the given field, if it can be converted to the expected type T
     */
    @warn_unused_result
    public func from<T: Convertible where T == T.ConvertedType>(field: String) throws -> T {
        return try self.from(field, transformation: T.fromMap)
    }

    /**
     Get an array of Convertible values from a field in the source data

     This transparently converts your types that conform to Convertible to an array on the Mappable type

     - parameter field: The field to retrieve from the source data, can be an empty string to return the
                        entire data set

     - throws: MapperError.MissingFieldError if the field doesn't exist
     - throws: MapperError.TypeMismatchError if the field exists but isn't an array of AnyObject
     - throws: Any error produced by the subsequent Convertible implementations

     - returns: The value for the given field, if it can be converted to the expected type [T]
     */
    @warn_unused_result
    public func from<T: Convertible where T == T.ConvertedType>(field: String) throws -> [T] {
        let value = try self.JSONFromField(field)
        if let JSON = value as? [AnyObject] {
            return try JSON.map(T.fromMap)
        }

        throw MapperError.TypeMismatchError(field: field, value: value, type: [AnyObject].self)
    }

    /**
     Get a Convertible value from a field in the source data

     This transparently converts your types that conform to Convertible to properties on the Mappable type

     - parameter field: The field to retrieve from the source data, can be an empty string to return the
                        entire data set

     - returns: The value for the given field, if it can be converted to the expected type T otherwise nil
     */
    @warn_unused_result
    public func optionalFrom<T: Convertible where T == T.ConvertedType>(field: String) -> T? {
        return try? self.from(field, transformation: T.fromMap)
    }

    /**
     Get an optional array of Convertible values from a field in the source data

     This transparently converts your types that conform to Convertible to an array on the Mappable type

     - parameter field: The field to retrieve from the source data, can be an empty string to return the
                        entire data set

     - returns: The value for the given field, if it can be converted to the expected type [T]
     */
    @warn_unused_result
    public func optionalFrom<T: Convertible where T == T.ConvertedType>(field: String) -> [T]? {
        return try? self.from(field)
    }

    /**
     Get an optional value from the given fields and source data. This returns the first non-nil value
     produced in order based on the array of fields

     - parameter fields: The array of fields to check from the source data.

     - returns: The first non-nil value to be produced from the array of fields, or nil if none exist
     */
    @warn_unused_result
    public func optionalFrom<T: Convertible where T == T.ConvertedType>(fields: [String]) -> T? {
        for field in fields {
            if let value: T = try? self.from(field) {
                return value
            }
        }

        return nil
    }

    // MARK: - Custom Transformation

    /**
     Get a typed value from the given field by using the given transformation

     - parameter field:          The field to retrieve from the source data, can be an empty string to return
                                 the entire data set
     - parameter transformation: The transformation function used to create the expected value

     - throws: Any exception thrown by the transformation function, if you're implementing the transformation
               function you should use `MapperError`, see the documentation there for more info

     - returns: The value of type T for the given field, if the transformation function doesn't throw
     */
    @warn_unused_result
    public func from<T>(field: String, transformation: AnyObject? throws -> T) rethrows -> T {
        return try transformation(try? self.JSONFromField(field))
    }

    /**
     Get an optional typed value from the given field by using the given transformation

     - parameter field:          The field to retrieve from the source data, can be an empty string to return
                                 the entire data set
     - parameter transformation: The transformation function used to create the expected value

     - returns: The value of type T for the given field, if the transformation function doesn't throw
                otherwise nil
     */
    @warn_unused_result
    public func optionalFrom<T>(field: String, transformation: AnyObject? throws -> T?) -> T? {
        return (try? transformation(try? self.JSONFromField(field))).flatMap { $0 }
    }

    // MARK: - Private

    /**
     Get the object for a given field. If an empty string is passed, return the entire data source. This
     allows users to create objects from multiple fields in the top level of the data source

     - parameter field: The field to extract from the data source, can be an empty string to return the entire
                        data source

     - throws: MapperError.MissingFieldError if the field doesn't exist

     - returns: The object for the given field
     */
    private func JSONFromField(field: String) throws -> AnyObject {
        if let value = field.isEmpty ? self.JSON : self.JSON.valueForKeyPath(field) {
            return value
        }

        throw MapperError.MissingFieldError(field: field)
    }
}
