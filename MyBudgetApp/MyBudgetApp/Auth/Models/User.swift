//
//  User.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 2/2/24.
//

import Foundation

class User: Decodable {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}
