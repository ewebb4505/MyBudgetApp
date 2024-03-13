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
    
    var createdAtDate: Date? {
        createDate(createdAt)
    }
    
    var expiresAtDate: Date? {
        createDate(expiresAt)
    }
    
    func hasExpired() -> Bool {
        let now = Date.now
        guard let expires = expiresAtDate else {
            return true
        }
        print("Has Token expired? \n\n now: \(now) \n\n expireDate: \(expires)")
        return now > expires
    }
    
    private func createDate(_ str: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let date = formatter.date(from: str) else {
            return nil
        }
        return date
    }
}
