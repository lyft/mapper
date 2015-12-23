import Foundation

/**
This extension provides support for `valueForKeyPath` on linux until it's added to the official Swift
foundation fork.
*/
#if os(Linux)
public extension NSDictionary {
    public func valueForKeyPath(keyPath: String) -> AnyObject? {
        let paths = keyPath.characters.split(".").map(String.init).map { $0.bridge() }
        var dictionary: NSDictionary? = self
        for i in 0 ..< paths.count - 1 {
            dictionary = dictionary?[paths[i]] as? NSDictionary
        }
        return paths.last.flatMap { dictionary?[$0] }
    }
}
#endif
