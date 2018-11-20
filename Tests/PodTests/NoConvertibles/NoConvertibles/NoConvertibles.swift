import Mapper

extension String: DefaultConvertible {}
extension Double: Convertible {
    public static func fromMap(_ value: Any) throws -> Double {
        return 0
    }
}

final class NoConvertibles: Mappable {
    let string: String
    let double: Double?

    init(map: Mapper) throws {
        self.string = try map.from("string")
        self.double = map.optionalFrom("double")
    }
}
