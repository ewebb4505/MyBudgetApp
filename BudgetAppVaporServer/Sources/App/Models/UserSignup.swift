//
//  UserSignup.swift
//
//
//  Created by Evan Webb on 1/31/24.
//

import Vapor

struct UserSignup: Content {
    let username: String
    let password: String
}

extension UserSignup: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("username", as: String.self, is: !.empty)
        validations.add("password", as: String.self, is: .count(6...))
    }
}
