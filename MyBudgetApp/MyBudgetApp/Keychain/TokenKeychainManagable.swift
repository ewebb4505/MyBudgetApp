//
//  TokenKeychainManagable.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 2/8/24.
//

import Foundation

protocol TokenKeychainManagable {
    static var idLabel: String { get }
    static func setToken(_ token: Token, id: String)
    static func removeToken(_ id: String)
    static func getToken(_ id: String) -> Token?
}
