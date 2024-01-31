//
//  APIManager.swift
//  BudgetApp
//
//  Created by Evan Webb on 10/1/23.
//

import Foundation

protocol APIManagerProtocol {
    func perform(_ request: RequestProtocol, authToken: String) async throws -> Data
    func requestToken() async throws -> Data
}

class APIManager: APIManagerProtocol {
    private let urlSession: URLSession

    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }

    func perform(_ request: RequestProtocol, authToken: String = "") async throws -> Data {
        let (data, response) = try await urlSession.data(for: request.createURLRequest(authToken: authToken))
        
        // TODO: handle errors here a little better.
        guard let httpResponse = response as? HTTPURLResponse,
                (httpResponse.statusCode == 200 || httpResponse.statusCode == 204) else {
            throw NetworkError.invalidServerResponse
        }
        return data
    }

    func requestToken() async throws -> Data {
        try await perform(AuthTokenRequest.auth)
    }
}


