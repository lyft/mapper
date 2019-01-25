import Foundation

extension Transform {
    /// A provided transformation function (see Transform and Mapper for uses) in order to create a dictionary
    /// from an array of values. The idea for this is to create a dictionary based on an array of values,
    /// using a custom function to extract the key used in the dictionary
    ///
    /// Example:
    ///
    /// // An enum with all possible HintIDs
    /// enum HintID: String {
    ///    ...
    /// }
    ///
    /// // A hint struct, which consists of an id and some text
    /// struct Hint: Mappable {
    ///    let id: HintID
    ///    let text: String
    ///
    ///    init(map: Mapper) throws {
    ///        try id   = map.from("id")
    ///        try text = map.from("text")
    ///    }
    /// }
    ///
    /// // An object that manages all the hints
    /// struct HintCoordinator: Mappable {
    ///    private let hints: [HintID: Hint]
    ///
    ///    ...
    ///
    ///    init(map: Mapper) throws {
    ///        // Use the `toDictionary` transformation to create a map of `Hint`s by their `HintID`s
    ///        try hints = map.from("hints", transformation: Transform.toDictionary { $0.id })
    ///    }
    /// }
    ///
    /// - parameter key:    A function to extract the key U from an instance of the Mappable object T
    /// - parameter object: The object to attempt to produce the objects and dictionary from, this is
    ///                     Any? to allow uses with transformations (see Mapper)
    ///
    /// - throws: MapperError.convertibleError if the given object is not an array of NSDictionarys
    ///
    /// - returns: A dictionary of [U: T] where the keys U are produced from the passed `key` function and the
    ///            values T are the objects
    public static func toDictionary<T, U>(key getKey: @escaping (T) -> U) ->
        (_ object: Any) throws -> [U: T] where T: Mappable
    {
        return { object in
            guard let objects = object as? [NSDictionary] else {
                throw MapperError.convertibleError(value: object, type: [NSDictionary].self)
            }

            var dictionary: [U: T] = [:]
            for object in objects {
                let model = try T(map: Mapper(JSON: object))
                dictionary[getKey(model)] = model
            }

            return dictionary
        }
    }
}
