//
//  UserKeychainManagable.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 2/8/24.
//

import Foundation

protocol UserKeychainManagable {
    static var idLabel: String { get }
    static func setUser(_ user: User)
    static func removeUser(_ user: User)
    static func getUser(_ username: String) -> User?
}
