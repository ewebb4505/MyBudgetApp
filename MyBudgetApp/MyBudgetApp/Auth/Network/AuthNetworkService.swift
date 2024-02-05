//
//  AuthNetworkService.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 2/3/24.
//

import Foundation

struct AuthNetworkService: AuthNetworkServiceProtocol {
    let requestManager: RequestManagerProtocol
    
    func loginUser(username: String, password: String) async -> SignUpResponse? {
        let req = AuthRequest.login(username, password)
        let user: SignUpResponse? = try? await requestManager.perform(req)
        return user
    }
    
    func logoutUser() async -> Bool {
        do {
            try await requestManager.performWithNoParsing(AuthRequest.logout)
            return true
        } catch {
            return false
        }
    }
    
    func createUser(username: String, password: String) async -> SignUpResponse? {
        let req = AuthRequest.signup(username, password)
        do {
            let user: SignUpResponse = try await requestManager.perform(req)
            return user
        } catch {
            print(error)
            return nil
        }
        
    }
}
