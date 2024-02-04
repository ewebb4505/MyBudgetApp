//
//  Token.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 2/3/24.
//

import Foundation

protocol TokenProtocol {
    var token: String { get }
}

class Token: TokenProtocol, Codable {
    var token: String
    
    init(token: String) {
        self.token = token
    }
}
