//
//  User.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 2/2/24.
//

import Foundation

protocol UserProtocol {
    var username: String { get }
    var id: UUID { get }
    var createdAt: Date { get }
    var updatedAt: Date { get }
}

class User: UserProtocol, Codable {
    var username: String
    var id: UUID
    var createdAt: Date
    var updatedAt: Date
    
    init(username: String,
         id: UUID,
         createdAt: Date,
         updatedAt: Date) {
        self.username = username
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
