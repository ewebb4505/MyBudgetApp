//
//  BudgetCategoryRequest.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 11/12/23.
//

import Foundation

enum BudgetCategoryRequest: RequestProtocol {
    case getBudgetCategories(UUID)
    case getBudgetCategoryTransactions(UUID)
    case createBudgetCategory(UUID, String, Double)
    case deleteBudgetCategory(UUID)
    
    var path: String {
        switch self {
        case .getBudgetCategories(_):
            "/categories"
        case.getBudgetCategoryTransactions(_):
            "/categories/transactions"
        case .createBudgetCategory(_, _, _):
            "/categories"
        case .deleteBudgetCategory(_):
            "/categories"
        }
    }
    
    var urlParams: [String : String?] {
        switch self {
        case .getBudgetCategories(let id):
            ["id":id.uuidString]
        case.getBudgetCategoryTransactions(let id):
            ["id":id.uuidString]
        case .createBudgetCategory(_, _, _):
            [:]
        case .deleteBudgetCategory(let id):
            ["id": id.uuidString]
        }
    }
    
    var params: [String : Any] {
        switch self {
        case .getBudgetCategories, .deleteBudgetCategory(_), .getBudgetCategoryTransactions(_):
            [:]
        case .createBudgetCategory(let id, let title, let maxAmount):
            ["title": title,
             "maxAmount": maxAmount,
             "budgetID": id.uuidString]
        }
    }
    
    var requestType: RequestType {
        switch self {
        case .getBudgetCategories, .getBudgetCategoryTransactions(_):
            return .GET
        case .createBudgetCategory(_, _, _):
            return .POST
        case .deleteBudgetCategory(_):
            return .DELETE
        }
    }
    
    var addAuthorizationToken: Bool {
        true
    }
}
