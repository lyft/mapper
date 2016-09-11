import Foundation

extension NSDictionary {
    func safeValue(forKeyPath keyPath: String) -> AnyObject? {
        var object: AnyObject? = self
        var keys = keyPath.characters.split(separator: ".").map(String.init)

        while keys.count > 0, let currentObject = object {
            let key = keys.remove(at: 0)
            object = (currentObject as? NSDictionary)?[key] as AnyObject
        }

        return object
    }
}
