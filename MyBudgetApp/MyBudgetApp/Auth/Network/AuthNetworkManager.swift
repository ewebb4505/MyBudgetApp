//
//  AuthNetworkManager.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 2/8/24.
//

import Foundation

class AuthNetworkManager: RequestManagerProtocol {
    let apiManager: NetworkRequestManagerProtocol
    let parser = DataParser()
    let username: String
    let password: String
    
    init(apiManager: NetworkRequestManagerProtocol = NetworkRequestManager(), username: String, password: String) {
        self.apiManager = apiManager
        self.username = username
        self.password = password
    }
    
    func perform<T>(_ request: RequestProtocol) async throws -> T where T : Decodable {
        let data = try await apiManager.perform(request, authToken: "")
        let decoded: T = try parser.parse(data: data)
        return decoded
    }
    
    func performWithNoParsing(_ request: RequestProtocol) async throws {
        let _ = try await apiManager.perform(request, authToken: "")
    }
}
