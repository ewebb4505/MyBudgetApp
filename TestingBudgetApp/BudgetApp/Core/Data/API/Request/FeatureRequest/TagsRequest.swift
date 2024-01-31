//
//  TagsRequest.swift
//  BudgetApp
//
//  Created by Evan Webb on 10/9/23.
//

import Foundation

enum TagsRequest: RequestProtocol {
    case getTags
    case createTag(String)
    case deleteTag(UUID)
    
    var path: String {
        switch self {
        case .getTags:
            "/tags"
        case .createTag(_):
            "/tags"
        case .deleteTag(_):
            "/tags"
        }
    }
    
    var urlParams: [String : String?] {
        switch self {
        case .getTags:
            [:]
        case .createTag(_):
            [:]
        case .deleteTag(let id):
            ["id": id.uuidString]
        }
    }
    
    var params: [String : Any] {
        switch self {
        case .getTags, .deleteTag(_):
            [:]
        case .createTag(let title):
            ["title": title]
        }
    }
    
    var requestType: RequestType {
        switch self {
        case .getTags:
            return .GET
        case .createTag(_):
            return .POST
        case .deleteTag(_):
            return .DELETE
        }
    }
    
    var addAuthorizationToken: Bool {
        false
    }
}
