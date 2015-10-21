public protocol Convertible {
    typealias ConvertedType = Self
    static func fromMap(value: AnyObject?) throws -> ConvertedType
}
