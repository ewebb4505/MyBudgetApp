//
//  AuthNetworkServiceProtocol.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 2/3/24.
//

import Foundation

protocol AuthNetworkServiceProtocol {
    func loginUser(username: String, password: String) async -> SignUpResponse?
    func logoutUser() async -> Bool
    func createUser(username: String, password: String) async -> SignUpResponse?
}
