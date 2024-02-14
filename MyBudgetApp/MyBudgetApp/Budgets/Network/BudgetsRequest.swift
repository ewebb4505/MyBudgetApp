//
//  BudgetsRequest.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 11/12/23.
//

import Foundation

enum BudgetRequest: RequestProtocol {
    case getBudgets(Bool)
    case createBudget(String, Date, Date, Double)
    case deleteBudget(UUID)
    
    var path: String {
        switch self {
        case .getBudgets(_):
            "/budgets"
        case .createBudget(_, _, _, _):
            "/budgets"
        case .deleteBudget(_):
            "/budgets"
        }
    }
    
    var urlParams: [String : String?] {
        switch self {
        case .getBudgets(let isActive):
            ["isActive": isActive ? "true" : "false"]
        case .createBudget(_, _, _, _):
            [:]
        case .deleteBudget(let id):
            ["id": id.uuidString]
        }
    }
    
    var params: [String : Any] {
        switch self {
        case .getBudgets(_), .deleteBudget(_):
            [:]
        case .createBudget(let title, let startDate, let endDate, let amount):
            ["title": title,
             "startDate": startDate.ISO8601Format(),
             "endDate": endDate.ISO8601Format(),
             "startingAmount": amount]
        }
    }
    
    var requestType: RequestType {
        switch self {
        case .getBudgets(_):
            return .GET
        case .createBudget(_, _, _, _):
            return .POST
        case .deleteBudget(_):
            return .DELETE
        }
    }
    
    var addAuthorizationToken: Bool {
        true
    }
}
