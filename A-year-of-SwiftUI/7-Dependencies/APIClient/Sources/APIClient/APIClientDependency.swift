//
//  APIClientDependency.swift
//  A-year-of-SwiftUI
//
//  Created by Quentin Fasquel on 06/02/2024.
//

import Dependencies

extension DependencyValues {
    public var apiClient: APIClientProtocol {
        get { self[APIClientDependencyKey.self] }
        set { self[APIClientDependencyKey.self] = newValue }
    }
}

public enum APIClientDependencyKey: TestDependencyKey {
    public static var previewValue: APIClientProtocol = APIClientMock()
    public static var testValue: APIClientProtocol = APIClientMock()
}
