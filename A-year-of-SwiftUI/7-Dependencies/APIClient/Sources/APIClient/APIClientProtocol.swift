
@_exported import Dependencies
import Foundation

public struct City: Identifiable {
    public var id: String
    public var name: String

    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

public protocol APIClientProtocol {
    func cities() async -> [City]
}

