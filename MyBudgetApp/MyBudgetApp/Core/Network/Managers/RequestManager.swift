//
//  RequestManager.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 11/12/23.
//

import Foundation

protocol RequestManagerProtocol {
    func perform<T: Decodable>(_ request: RequestProtocol) async throws -> T
    func performWithNoParsing(_ request: RequestProtocol) async throws
}

class RequestManager: RequestManagerProtocol {
    let apiManager: NetworkRequestManagerProtocol
    let parser: DataParserProtocol
    let accessTokenManager: AccessTokenManagerProtocol

    init(apiManager: NetworkRequestManagerProtocol = NetworkRequestManager(),
         parser: DataParserProtocol = DataParser(),
         accessTokenManager: AccessTokenManagerProtocol = AccessTokenManager()) {
            self.apiManager = apiManager
            self.parser = parser
            self.accessTokenManager = accessTokenManager
    }

    func requestAccessToken() async throws -> String {
        if accessTokenManager.isTokenValid() {
            return accessTokenManager.fetchToken()
        }

        let data = try await apiManager.requestToken()
        let token: APIToken = try parser.parse(data: data)
        try accessTokenManager.refreshWith(apiToken: token)
        return token.bearerAccessToken
    }

    func perform<T: Decodable>(_ request: RequestProtocol) async throws -> T {
        // let authToken = try await requestAccessToken()
        let data = try await apiManager.perform(request, authToken: "")
        print(data)
        let decoded: T = try parser.parse(data: data)
        return decoded
    }
    
    func performWithNoParsing(_ request: RequestProtocol) async throws {
       let _ = try await apiManager.perform(request, authToken: "")
    }
}
