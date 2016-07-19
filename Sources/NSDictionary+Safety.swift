import Foundation

extension NSDictionary {
    func safeValueForKeyPath(keyPath: String) -> AnyObject? {
        var object: AnyObject? = self
        var keys = keyPath.characters.split(".").map(String.init)

        while keys.count > 0, let currentObject = object {
            let key = keys.removeAtIndex(0)
            object = (currentObject as? NSDictionary)?[key]
        }

        return object
    }
}
