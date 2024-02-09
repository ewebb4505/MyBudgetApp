//
//  AuthTokenRequest.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 11/12/23.
//

import Foundation

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
