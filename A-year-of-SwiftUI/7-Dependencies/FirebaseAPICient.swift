//
//  APICient.swift
//  A-year-of-SwiftUI
//
//  Created by Quentin Fasquel on 06/02/2024.
//

import APIClient
import Foundation

extension APIClientDependencyKey: DependencyKey {
    public static var liveValue: APIClientProtocol = FirebaseAPIClient()
}

final class FirebaseAPIClient: APIClientProtocol {
    func cities() async -> [APIClient.City] {
        return ["THIS", "IS", "NOT", "THE", "LIVE", "VALUE"].map {
            City(id: UUID().uuidString, name: $0)
        }
    }
}
