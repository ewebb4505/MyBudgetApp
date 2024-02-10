//
//  PasswordKeychainManager.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 2/10/24.
//

import Foundation

class PasswordKeychainManager {
    static var idLabel: String = "MyBudgetApp Label"
    static var service: String = "com.MyBudgetApp.app"
    
    static func setPassword(_ password: String, id: UUID) {
        KeychainHelper.standard.save<String>(password, service: service, account: id.uuidString)
    }
    
    static func removePassword(id: UUID) {
        KeychainHelper.standard.delete(service: service, account: id.uuidString)
    }
    
    static func getPassword(id: UUID) -> String? {
        KeychainHelper.standard.read(service: service, account: id.uuidString, type: String.self)
    }
}
