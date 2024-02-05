//
//  User.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 2/2/24.
//

import Foundation

protocol UserProtocol {
    var username: String { get }
    var id: String { get }
    var createdAt: String { get }
    var updatedAt: String { get }
}

struct User: UserProtocol, Codable, Equatable {
    var username: String
    var id: String
    var createdAt: String
    var updatedAt: String
    
    init(username: String,
         id: String,
         createdAt: String,
         updatedAt: String) {
        self.username = username
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}
