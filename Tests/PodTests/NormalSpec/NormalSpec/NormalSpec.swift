import Mapper

final class NormalSpec: Mappable {
    let string: String
    let double: Double?

    init(map: Mapper) throws {
        self.string = try map.from("string")
        self.double = map.optionalFrom("double")
    }
}
