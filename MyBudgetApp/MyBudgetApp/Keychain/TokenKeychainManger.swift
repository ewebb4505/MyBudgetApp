//
//  TokenKeychainManger.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 2/3/24.
//

import Foundation
import Security

protocol TokenKeychainManagable {
    static var idLabel: String { get }
    func setToken(_ token: Token)
    func removeToken(_ token: Token)
    func getToken(_ token: String) -> Token?
}

class TokenKeychainManager: TokenKeychainManagable {
    static var idLabel: String = "MyBudgetApp Label"
    
    func setToken(_ token: Token) {
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: token.token,
            kSecAttrLabel as String: Self.idLabel
        ]
        
        if SecItemAdd(attributes as CFDictionary, nil) == noErr {
            print("\n\n token info saved to keychain \n\n")
        } else {
            print("=== ERROR === \n\n Could not save token to keychain \n\n")
        }
    }
    
    func removeToken(_ token: Token) {
        // Set query
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: token.token,
        ]
        // Find user and delete
        if SecItemDelete(query as CFDictionary) == noErr {
            print("User removed successfully from the keychain")
        } else {
            print("Something went wrong trying to remove the user from the keychain")
        }
    }
    
    func getToken(_ token: String) -> Token? {
        // Set query
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: token,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true,
        ]
        var item: CFTypeRef?
        // Check if user exists in the keychain
        if SecItemCopyMatching(query as CFDictionary, &item) == noErr {
            // Extract result
            if let existingItem = item as? [String: Any],
               let createdAt = existingItem[kSecAttrAccount as String] as? Date,
               let expiresAt = existingItem[kSecAttrAccount as String] as? Date,
               let tokenData = existingItem[kSecValueData as String] as? Data,
               let token = String(data: tokenData, encoding: .utf8)
            {
                print(token)
                return Token(token: token, createdAt: createdAt, expiresAt: expiresAt)
            }
            return nil
        } else {
            print("Something went wrong trying to find the user in the keychain")
            return nil
        }
    }
}
