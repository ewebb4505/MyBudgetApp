//
//  BudgetRequest.swift
//  BudgetApp
//
//  Created by Evan Webb on 10/25/23.
//

import Foundation

enum BudgetRequest: RequestProtocol {
    case getBudgets
    case createBudget(String, Date, Date, Double)
    case deleteBudget(UUID)
    
    var path: String {
        switch self {
        case .getBudgets:
            "/budgets"
        case .createBudget(_, _, _, _):
            "/budgets"
        case .deleteBudget(_):
            "/budgets"
        }
    }
    
    var urlParams: [String : String?] {
        switch self {
        case .getBudgets:
            [:]
        case .createBudget(_, _, _, _):
            [:]
        case .deleteBudget(let id):
            ["id": id.uuidString]
        }
    }
    
    var params: [String : Any] {
        switch self {
        case .getBudgets, .deleteBudget(_):
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
        case .getBudgets:
            return .GET
        case .createBudget(_, _, _, _):
            return .POST
        case .deleteBudget(_):
            return .DELETE
        }
    }
    
    var addAuthorizationToken: Bool {
        false
    }
}
