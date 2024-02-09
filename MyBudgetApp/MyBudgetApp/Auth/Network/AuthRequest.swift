//
//  AuthRequest.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 2/2/24.
//

import Foundation

enum AuthRequest: RequestProtocol {
    case login(String, String)
    case logout
    case signup(String, String)
    case me
    
    var path: String {
        switch self {
        case .login(_, _):
            "/users/login"
        case .logout:
            "/users/logout"
        case .signup(_, _):
            "/users/signup"
        case .me:
            "/users/me"
        }
    }
    
    var urlParams: [String : String?] {
        [:]
    }
    
    var params: [String : Any] {
        switch self {
        case .signup(let username, let password):
            ["username": username, "password": password]
        case .logout, .me, .login(_, _):
            [:]
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .login(let username, let password):
            ["username": username, "password": password]
        case .logout, .me, .signup(_, _):
            [:]
        }
    }
    
    var requestType: RequestType {
        .POST
    }
    
    var addAuthorizationToken: Bool {
        switch self {
        case .login(_, _):
            false
        case .logout:
            true
        case .signup(_, _):
            false
        case .me:
            true
        }
    }
    
    var addBasicAuthHeader: Bool {
        switch self {
        case .login(_, _):
            true
        case .logout, .signup(_, _), .me:
            false
        }
    }
}
