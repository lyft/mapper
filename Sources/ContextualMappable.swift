import Foundation

public protocol ContextualMappable {
    associatedtype Context
    /// Define how your custom object is created from a Mapper object with a context.
    init(map: Mapper, context: Context) throws
}
