//
//  TokenKeychainManger.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 2/3/24.
//

import Foundation
import Security

class TokenKeychainManager: TokenKeychainManagable {
    static var idLabel: String = "MyBudgetApp Label"
    static var service: String = "com.MyBudgetApp.app"
    
    static func setToken(_ token: Token, id: String) {
        KeychainHelper.standard.save<Token>(token, service: service, account: id)
    }
    
    static func removeToken(_ id: String) {
        KeychainHelper.standard.delete(service: service, account: id)
    }
    
    static func getToken(_ id: String) -> Token? {
        KeychainHelper.standard.read(service: service, account: id, type: Token.self)
    }
}
