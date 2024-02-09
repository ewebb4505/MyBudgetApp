//
//  AppEnvironmentManager.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 1/31/24.
//

import Foundation
import Combine

@Observable
final class AppEnvironmentManager {
    
    static let instance = AppEnvironmentManager()
    
    var showDebugSettings: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    var showDebugMenu: Bool = false
    var user: User? = nil
    
    private init() {
        user = UserKeychainManager.getUser(getUsername() ?? "")
    }
    
    //MARK: User Management
    func saveUsername(username: String) {
        UserDefaults.standard.set(username, forKey: "savedUsername")
    }
    
    func getUsername() -> String? {
        return UserDefaults.standard.string(forKey: "savedUsername")
    }
    
    func removeUsername() {
        UserDefaults.standard.removeObject(forKey: "savedUsername")
    }
    
    func setUser(_ user: User) {
        saveUsername(username: user.username)
        UserKeychainManager.setUser(user)
        self.user = user
    }
    
    func getUser() {
        user = UserKeychainManager.getUser(getUsername() ?? "")
    }
    
    func removeUser() {
        guard let user else {
            return
        }
        UserKeychainManager.removeUser(user)
    }
    
    func userIsSignedIn() -> Bool {
        user != nil
    }
    
    //MARK: Token Management
    
    func setToken(_ token: Token) {
        guard let user else {
            return
        }
        TokenKeychainManager.setToken(token, id: user.id)
    }
    
    func getToken() -> Token? {
        TokenKeychainManager.getToken(user?.id ?? "")
    }
    
    func removeToken() {
        TokenKeychainManager.removeToken(user?.id ?? "")
    }}
