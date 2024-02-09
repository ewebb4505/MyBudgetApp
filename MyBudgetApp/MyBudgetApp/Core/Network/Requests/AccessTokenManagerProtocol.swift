//
//  AccessTokenManagerProtocol.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 2/8/24.
//

import Foundation

protocol AccessTokenManagerProtocol {
  func isTokenValid() -> Bool
  func fetchToken() -> String
  func refreshWith(apiToken: APIToken) throws
}
