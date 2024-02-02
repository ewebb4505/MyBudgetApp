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
    
    var path: String {
        ""
    }
    
    var urlParams: [String : String?] {
        [:]
    }
    
    var params: [String : Any] {
        [:]
    }
    
    var requestType: RequestType {
        .POST
    }
    
    var addAuthorizationToken: Bool {
        false
    }
}
