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
    func setUser(_ user: User)
    func removeUser(_ user: User)
    func getUser(_ username: String) -> User?
}

class UserKeychainManager: UserKeychainManagable {
    static var idLabel: String = "MyBudgetApp Label"
    
    func setUser(_ user: User) {
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: user.username,
            kSecValueData as String: user.password,
            kSecAttrLabel as String: Self.idLabel
        ]
        
        if SecItemAdd(attributes as CFDictionary, nil) == noErr {
            print("\n\n user info saved to keychain \n\n")
        } else {
            print("=== ERROR === \n\n Could not save user to keychain \n\n")
        }
    }
    
    func removeUser(_ user: User) {
        // Set query
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: user.username,
        ]
        // Find user and delete
        if SecItemDelete(query as CFDictionary) == noErr {
            print("User removed successfully from the keychain")
        } else {
            print("Something went wrong trying to remove the user from the keychain")
        }
    }
    
    func getUser(_ username: String) -> User? {
        // Set query
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true,
        ]
        var item: CFTypeRef?
        // Check if user exists in the keychain
        if SecItemCopyMatching(query as CFDictionary, &item) == noErr {
            // Extract result
            if let existingItem = item as? [String: Any],
               let username = existingItem[kSecAttrAccount as String] as? String,
               let passwordData = existingItem[kSecValueData as String] as? Data,
               let password = String(data: passwordData, encoding: .utf8)
            {
                print(username)
                print(password)
                return User(username: username,
                            password: password)
            }
            return nil
        } else {
            print("Something went wrong trying to find the user in the keychain")
            return nil
        }
    }
}
