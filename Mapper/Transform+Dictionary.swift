public extension Transform {
    public static func toDictionary<T, U where T: Mappable, U: Hashable>(key getKey: T -> U)
        (object: AnyObject?) throws -> [U: T]
    {
        guard let objects = object as? [NSDictionary] else {
            throw MapperError()
        }

        var dictionary: [U: T] = [:]
        for object in objects {
            let model = try T(map: Mapper(JSON: object))
            dictionary[getKey(model)] = model
        }

        return dictionary
    }
}
