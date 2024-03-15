//
//  TagsRequest.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 11/12/23.
//

import Foundation

enum TagsRequest: RequestProtocol {
    case getTags
    case getTransactions(Tag.ID, Int, Date?, Date?)
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
        case .getTransactions(_, _, _, _):
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
        case .getTransactions(_, _, _, _):
            [:]
        }
    }
    
    var params: [String : Any] {
        switch self {
        case .getTags, .deleteTag(_):
            [:]
        case .createTag(let title):
            ["title": title]
        case .getTransactions(_, _, _, _):
            [:]
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
        case .getTransactions(_, _, _, _):
            return .GET
        }
    }
    
    var addAuthorizationToken: Bool {
        true
    }
}
