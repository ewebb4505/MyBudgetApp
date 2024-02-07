//
//  Token.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 2/3/24.
//

import Foundation

protocol TokenProtocol {
    var token: String { get }
    var createdAt: String { get }
    var expiresAt: String { get }
}

class Token: TokenProtocol, Codable {
    var token: String
    var createdAt: String
    var expiresAt: String
    
    init(token: String, createAt: String, expiresAt: String) {
        self.token = token
        self.createdAt = createAt
        self.expiresAt = expiresAt
    }
}
