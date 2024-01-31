//
//  AuthTokenRequest.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 11/12/23.
//

import Foundation

protocol AccessTokenManagerProtocol {
  func isTokenValid() -> Bool
  func fetchToken() -> String
  func refreshWith(apiToken: APIToken) throws
}

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

enum AppUserDefaultsKeys {
  static let expiresAt = "expiresAt"
  static let bearerAccessToken = "bearerAccessToken"
}

struct APIToken {
  let tokenType: String
  let expiresIn: Int
  let accessToken: String
  private let requestedAt = Date()
}

// MARK: - Codable
extension APIToken: Codable {
  enum CodingKeys: String, CodingKey {
    case tokenType
    case expiresIn
    case accessToken
  }
}

// MARK: - Helper properties
extension APIToken {
  var expiresAt: Date {
    Calendar.current.date(byAdding: .second, value: expiresIn, to: requestedAt) ?? Date()
  }

  var bearerAccessToken: String {
    "\(tokenType) \(accessToken)"
  }
}

enum AuthTokenRequest: RequestProtocol {
  case auth

  var path: String {
    "/v2/oauth2/token"
  }

  var params: [String: Any] {
    [
      "grant_type": APIConstants.grantType,
      "client_id": APIConstants.clientId,
      "client_secret": APIConstants.clientSecret
    ]
  }

  var addAuthorizationToken: Bool {
    false
  }

  var requestType: RequestType {
    .POST
  }
}
