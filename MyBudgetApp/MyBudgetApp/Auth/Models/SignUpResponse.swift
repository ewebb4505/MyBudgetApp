//
//  SignUpResponse.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 2/4/24.
//

import Foundation

struct SignUpResponse: Decodable {
    var user: User
    var token: Token
}
