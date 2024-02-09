//
//  AccessTokenManager.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 2/8/24.
//

import Foundation

class AccessTokenManager {
  private let userDefaults: UserDefaults
  private var accessToken: String?
  private var expiresAt = Date()

  init(userDefaults: UserDefaults = .standard) {
    self.userDefaults = userDefaults
  }
}

// MARK: - AccessTokenManagerProtocol
extension AccessTokenManager: AccessTokenManagerProtocol {
  func isTokenValid() -> Bool {
    accessToken = getToken()
    expiresAt = getExpirationDate()
    return accessToken != nil && expiresAt.compare(Date()) == .orderedDescending
  }

  func fetchToken() -> String {
    guard let token = accessToken else {
      return ""
    }
    return token
  }

  func refreshWith(apiToken: APIToken) throws {
    let expiresAt = apiToken.expiresAt
    let token = apiToken.bearerAccessToken

    save(token: apiToken)
    self.expiresAt = expiresAt
    self.accessToken = token
  }
}

// MARK: - Token Expiration
private extension AccessTokenManager {
  func save(token: APIToken) {
    userDefaults.set(token.expiresAt.timeIntervalSince1970, forKey: AppUserDefaultsKeys.expiresAt)
    userDefaults.set(token.bearerAccessToken, forKey: AppUserDefaultsKeys.bearerAccessToken)
  }

  func getExpirationDate() -> Date {
    Date(timeIntervalSince1970: userDefaults.double(forKey: AppUserDefaultsKeys.expiresAt))
  }

  func getToken() -> String? {
    userDefaults.string(forKey: AppUserDefaultsKeys.bearerAccessToken)
  }
}