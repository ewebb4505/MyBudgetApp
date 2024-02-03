//
//  User.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 2/2/24.
//

import Foundation

protocol UserProtocol {
    var username: String { get }
    var password: String { get }
}

class User: UserProtocol, Codable {
    var username: String
    var password: String
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
