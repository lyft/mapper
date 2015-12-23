import Foundation
import Mapper
import XCTest

XCTMain([
    ConvertibleValueTests(),
    CustomTransformationTests(),
    InitializerTests(),
    MappableValueTests(),
    NormalValueTests(),
    OptionalValueTests(),
    RawRepresentibleValueTests(),
    TransformTests(),
])

#if os(Linux)
extension Mappable {
    public static func from<T, U>(JSON: [T: U]) -> Self? {
        return self.from(JSON.bridge())
    }

    public static func from(JSON: [String: [[String: String]]]) -> Self? {
        let dictionary = NSMutableDictionary()
        for (key, array) in JSON {
            let items = NSMutableArray()
            for dictionary in array {
                items.addObject(dictionary.bridge())
            }

            dictionary[key.bridge()] = items
        }

        return self.from(dictionary)
    }

    public static func from(JSON: [String: [String]]) -> Self? {
        let dictionary = NSMutableDictionary()
        for (key, array) in JSON {
            let items = NSMutableArray()
            for string in array {
                    items.addObject(string.bridge())
            }
            dictionary[key.bridge()] = items
        }
        return self.from(dictionary)
    }
}
#endif
