extension NSURL: Convertible {
    public static func fromMap(value: AnyObject?) throws -> NSURL {
        if let string = value as? String, let URL = self.init(string: string) {
            return URL
        }

        throw MapperError()
    }
}
