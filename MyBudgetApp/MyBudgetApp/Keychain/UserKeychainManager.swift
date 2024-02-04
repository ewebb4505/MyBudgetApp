//
//  UserKeychainManager.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 2/3/24.
//

import Foundation
import Security

protocol UserKeychainManagable {
    static var idLabel: String { get }
    static func setUser(_ user: User)
    static func removeUser(_ user: User)
    static func getUser(_ username: String) -> User?
}

class UserKeychainManager: UserKeychainManagable {
    static var idLabel: String = "MyBudgetApp Label"
    static var service: String = "com.MyBudgetApp.app"
    
    static func setUser(_ user: User) {
        KeychainHelper.standard.save<User>(user, service: service, account: user.username)
    }
    
    static func removeUser(_ user: User) {
        KeychainHelper.standard.delete(service: service, account: user.username)
    }
    
    static func getUser(_ username: String) -> User? {
        KeychainHelper.standard.read(service: service, account: username, type: User.self)
    }
}
