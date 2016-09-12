/**
 The only error Mapper produces when failing to fetch/convert/or otherwise create a value
 if a Mapper function is marked as throws, any error produced internally *will* be a `MapperError`

 Custom implementations of Mappable, Convertible, or transformation functions can throw any error they desire

 - ConvertibleError:     An error produced by a convertible implementation
 - CustomError:          Any custom error, can be thrown by any consumer
 - InvalidRawValueError: The corresponding value matches the type's raw value, but the initializer failed
 - MissingFieldError:    An error thrown when the desired key isn't in the JSON
 - TypeMismatchError:    Thrown when the desired key exists in the JSON, but does not match the expected type
 */
public enum MapperError: Error {
    case convertibleError(value: Any?, type: Any.Type)
    case customError(field: String?, message: String)
    case invalidRawValueError(field: String, value: Any, type: Any.Type)
    case missingFieldError(field: String)
    case typeMismatchError(field: String, value: Any, type: Any.Type)
}
