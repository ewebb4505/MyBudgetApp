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
        user = UserKeychainManager.getUser(AppEnvironmentManager.getUsername() ?? "")
    }
    
    static func saveUsername(username: String) {
        UserDefaults.standard.set(username, forKey: "savedUsername")
    }
    
    static func getUsername() -> String? {
        return UserDefaults.standard.string(forKey: "savedUsername")
    }
    
    static func removeUsername() {
        UserDefaults.standard.removeObject(forKey: "savedUsername")
    }
    
    func setUser(_ user: User) {
        UserKeychainManager.setUser(user)
        self.user = user
    }
}
