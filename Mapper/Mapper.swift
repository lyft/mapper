public struct Mapper {
    private let JSON: NSDictionary

    public init(JSON: NSDictionary) {
        self.JSON = JSON
    }

    // MARK: - T

    public func from<T>(field: String) throws -> T {
        if let value = self.JSONFromField(field) as? T {
            return value
        }

        throw MapperError()
    }

    public func optionalFrom<T>(field: String) -> T? {
        return try? self.from(field)
    }

    // MARK: - T: RawRepresentable

    public func from<T: RawRepresentable>(field: String) throws -> T {
        if let rawValue = self.JSONFromField(field) as? T.RawValue,
            let value = T(rawValue: rawValue)
        {
            return value
        }

        throw MapperError()
    }

    public func optionalFrom<T: RawRepresentable>(field: String) -> T? {
        return try? self.from(field)
    }

    // MARK: - T: Mappable

    public func from<T: Mappable>(field: String) throws -> T {
        if let JSON = self.JSONFromField(field) as? NSDictionary {
            return try T(map: Mapper(JSON: JSON))
        }

        throw MapperError()
    }

    public func from<T: Mappable>(field: String) throws -> [T] {
        if let JSON = self.JSONFromField(field) as? [NSDictionary] {
            return try JSON.map { try T(map: Mapper(JSON: $0)) }
        }

        throw MapperError()
    }

    public func optionalFrom<T: Mappable>(field: String) -> T? {
        return try? self.from(field)
    }

    public func optionalFrom<T: Mappable>(field: String) -> [T]? {
        return try? self.from(field)
    }

    // MARK: - T: Convertible

    public func from<T: Convertible where T == T.ConvertedType>(field: String) throws -> T {
        return try self.from(field, transformation: T.fromMap)
    }

    public func from<T: Convertible where T == T.ConvertedType>(field: String) throws -> [T] {
        if let JSON = self.JSONFromField(field) as? [AnyObject] {
            return try JSON.map(T.fromMap)
        }

        throw MapperError()
    }

    public func optionalFrom<T: Convertible where T == T.ConvertedType>(field: String) -> T? {
        return try? self.from(field, transformation: T.fromMap)
    }

    public func optionalFrom<T: Convertible where T == T.ConvertedType>(field: String) -> [T]? {
        return try? self.from(field)
    }

    // MARK: - Custom Transformation

    public func from<T>(field: String, transformation: AnyObject? throws -> T) rethrows -> T {
        return try transformation(self.JSONFromField(field))
    }

    public func optionalFrom<T>(field: String, transformation: AnyObject? throws -> T?) -> T? {
        return (try? transformation(self.JSONFromField(field))).flatMap { $0 }
    }

    // MARK: - Private

    private func JSONFromField(field: String) -> AnyObject? {
        return field.isEmpty ? self.JSON : self.JSON.valueForKeyPath(field)
    }
}
