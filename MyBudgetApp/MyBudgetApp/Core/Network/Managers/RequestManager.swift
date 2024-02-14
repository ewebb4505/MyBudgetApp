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

    func requestAccessToken() -> String {
        // TODO: this sucks. refactor
        let username = UserDefaults.standard.string(forKey: "savedUsername")
        let user = UserKeychainManager.getUser(username ?? "")
        let token = TokenKeychainManager.getToken(user?.id ?? "")
        return token?.token ?? ""
    }

    func perform<T: Decodable>(_ request: RequestProtocol) async throws -> T {
        let authToken = requestAccessToken()
        let data = try await apiManager.perform(request, authToken: authToken)
        let decoded: T = try parser.parse(data: data)
        return decoded
    }
    
    func performWithNoParsing(_ request: RequestProtocol) async throws {
        let authToken = requestAccessToken()
        let _ = try await apiManager.perform(request, authToken: authToken)
    }
}
