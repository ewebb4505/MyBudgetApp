//
//  Token.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 2/3/24.
//

import Foundation

protocol TokenProtocol {
    var token: String { get }
    var createdAt: Date { get }
    var expiresAt: Date { get }
}

class Token: TokenProtocol {
    var token: String
    var createdAt: Date
    var expiresAt: Date
    
    init(token: String, createdAt: Date, expiresAt: Date) {
        self.token = token
        self.createdAt = createdAt
        self.expiresAt = expiresAt
    }
}
