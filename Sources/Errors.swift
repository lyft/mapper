/**
 The only error Mapper produces when failing to fetch/convert/or otherwise create a value
 if a Mapper function is marked as throws, any error produced internally *will* be a `MapperError`

 Custom implementations of Mappable, Convertible, or transformation functions can throw any error they desire
 */
public enum MapperError: ErrorType {
    case MapError(String)

    @warn_unused_result
    public init(message: String) {
        self = .MapError(message)
    }
}
