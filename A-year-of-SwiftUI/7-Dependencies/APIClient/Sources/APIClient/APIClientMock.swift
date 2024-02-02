//
//  File.swift
//  
//
//  Created by Quentin Fasquel on 06/02/2024.
//

import Foundation

public final class APIClientMock: APIClientProtocol {

    public init() {
    }

    public func cities() async -> [City] {
        try? await Task.sleep(for: .seconds(1))
        return [
            "Wimereux",
            "Paris",
            "Los Angeles",
            "Palo Alto",
            "San Francisco",
            "Bordeaux"
        ].map {
            City(id: UUID().uuidString, name: $0)
        }
    }
}
