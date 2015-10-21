public protocol Mappable {
    init(map: Mapper) throws
    static func from(JSON: NSDictionary) -> Self?
}

public extension Mappable {
    public static func from(JSON: NSDictionary) -> Self? {
        return try? self.init(map: Mapper(JSON: JSON))
    }
}
