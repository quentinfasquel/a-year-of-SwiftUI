//
//  APIClient.swift
//  A-year-of-SwiftUI
//
//  Created by Quentin Fasquel on 06/02/2024.
//

import Foundation

protocol APIClientProtocol {
    func cities() async -> [City]
}

final class APIClient: APIClientProtocol {
    func cities() async -> [City] {
        assertionFailure()
        return []
    }
}

final class APIClientMock: APIClientProtocol {
    func cities() async -> [City] {
        try? await Task.sleep(for: .seconds(1))
        return [
            "Bordeaux",
            "Wimereux",
            "Lille",
            "Lyon",
            "Marseille"
        ].map {
            City(id: UUID().uuidString, name: $0)
        }
    }
}
