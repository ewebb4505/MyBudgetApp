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
    
    let network = AuthNetworkService(requestManager: RequestManager())
    
    private init() {
        user = UserKeychainManager.getUser(getUsername() ?? "")
    }
    
    //MARK: User Management
    
    //TODO: Refactor
    func setUserOnLaunch() async {
        user = UserKeychainManager.getUser(getUsername() ?? "")
        let token = getToken()
        if let token, let expireDate = token.expiresAtDate {
            if expireDate < .now {
                if let user, let password = getPassword() {
                    if let login = await network.loginUser(username: user.username, password: password) {
                        setToken(login.token)
                    }
                } else {
                    return
                }
            }
        } else {
            if let user, let password = getPassword() {
                if let login = await network.loginUser(username: user.username, password: password) {
                    setToken(login.token)
                }
            } else {
                return
            }
        }
    }
    
    func saveUsername(username: String) {
        UserDefaults.standard.set(username, forKey: "savedUsername")
    }
    
    func getUsername() -> String? {
        UserDefaults.standard.string(forKey: "savedUsername")
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
        guard let signedInUser = user else {
            return
        }
        UserKeychainManager.removeUser(signedInUser)
        user = nil
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
    }
    
    func isTokenValid() -> Bool {
        getToken()?.hasExpired() ?? false
    }
    
    //MARK: Password Management
    
    func setPassword(_ password: String) {
        let id = UUID()
        UserDefaults.standard.set(id.uuidString, forKey: "passwordID")
        PasswordKeychainManager.setPassword(password, id: id)
    }
    
    func getPassword() -> String? {
        guard let passwordID = UserDefaults.standard.string(forKey: "passwordID") else {
            return nil
        }
        
        guard let passwordUUID = UUID(uuidString: passwordID) else {
            return nil
        }
        
        return PasswordKeychainManager.getPassword(id: passwordUUID)
    }
    
    func removePassword() {
        guard let passwordID = UserDefaults.standard.string(forKey: "passwordID") else {
            return
        }
        
        guard let passwordUUID = UUID(uuidString: passwordID) else {
            return
        }
        
        PasswordKeychainManager.removePassword(id: passwordUUID)
    }
}
    
