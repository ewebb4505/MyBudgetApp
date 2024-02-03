//
//  RequestProtocol.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 11/12/23.
//

import Foundation

protocol RequestProtocol {
    var path: String { get }
    var headers: [String: String] { get }
    var params: [String: Any] { get }
    var urlParams: [String: String?] { get }
    var addAuthorizationToken: Bool { get }
    var requestType: RequestType { get }
    var addBasicAuthHeader: Bool { get }
}

extension RequestProtocol {
    var host: String {
        APIConstants.host
    }

    var addAuthorizationToken: Bool {
        true
    }

    var params: [String: Any] {
        [:]
    }

    var urlParams: [String: String?] {
        [:]
    }

    var headers: [String: String] {
        [:]
    }
    
    func createURLRequest(authToken: String, username: String, password: String) throws -> URLRequest {
        var components = URLComponents()
        components.scheme = "http"
        components.host = host
        components.path = path
        components.port = 8080
        
        if !urlParams.isEmpty {
            components.queryItems = urlParams.map {
              URLQueryItem(name: $0, value: $1)
            }
        }

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        print(url)

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = requestType.rawValue

        if !headers.isEmpty {
            urlRequest.allHTTPHeaderFields = headers
        }

        if addAuthorizationToken {
            urlRequest.setValue(authToken, forHTTPHeaderField: "Authorization")
        }
        
        if addBasicAuthHeader {
            let loginString = "\(username):\(password)".data(using: .utf8)!
            urlRequest.setValue("Basic \(loginString)", forHTTPHeaderField: "Authorization")
        }

        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if !params.isEmpty {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params)
        }

        return urlRequest
    }
    
    var addBasicAuthHeader: Bool {
        false
    }
}




