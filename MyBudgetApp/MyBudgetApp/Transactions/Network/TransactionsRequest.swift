//
//  TransactionsRequest.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 11/12/23.
//

import Foundation

enum TransactionsRequest: RequestProtocol {
    case getTransactions(Date?, Date?, Date?, Int?)
    case createTransactions(String, Double, Date, [UUID])
    case deleteTransaction(UUID)
    case addTagsToTransaction(transactionID: UUID, tagIDs: [UUID])
    case addTransactionToBudgetCategory(transactionID: UUID, categoryID: UUID)
    
    var path: String {
        switch self {
        case .getTransactions(_, _, _, _):
            "/transactions"
        case .createTransactions(_, _, _, _):
            "/transaction"
        case .deleteTransaction(_):
            "/transaction"
        case .addTagsToTransaction(_, _):
            "/transaction/tags"
        case .addTransactionToBudgetCategory(_, _):
            "/transactions/budget/category"
        }
    }
    
    var urlParams: [String : String?] {
        switch self {
        case .getTransactions(let fromDate, let toDate, let onDate, let n):
            var getParams: [String : String?] = [:]
            
            if let n {
                getParams["nParam"] = String(n)
            }
            
            if let onDate {
                getParams["onDate"] = onDate.ISO8601Format()
            }
            
            if let fromDate, let toDate {
                getParams["toDate"] = toDate.ISO8601Format()
                getParams["fromDate"] = fromDate.ISO8601Format()
            } else if let fromDate {
                getParams["fromDate"] = fromDate.ISO8601Format()
            } else if let toDate {
                getParams["toDate"] = toDate.ISO8601Format()
            }
            
            return getParams
        case .createTransactions(_, _, _, _):
            return [:]
        case .deleteTransaction(let id):
            return ["transactionID": id.uuidString]
        case .addTagsToTransaction(_, _):
            return [:]
        case .addTransactionToBudgetCategory(_, _):
            return [:]
        }
    }
    
    var params: [String : Any] {
        switch self {
        case .getTransactions(_, _, _, _), .deleteTransaction(_):
            [:]
        case .createTransactions(let title, let amount, let date, let tags):
            ["title": title,
             "amount": amount,
             "date": date.ISO8601Format(),
             "tags": tags.map({ $0.uuidString })]
        case .addTagsToTransaction(let transactionID, let tagIDs):
            ["id": transactionID.uuidString, "tagIDs": tagIDs.map({ $0.uuidString })]
        case .addTransactionToBudgetCategory(let transactionID, let categoryID):
            ["transactionID": transactionID.uuidString, "budgetCategoryID": categoryID.uuidString]
        }
    }
    
    var requestType: RequestType {
        switch self {
        case .getTransactions(_, _, _, _):
            return .GET
        case .createTransactions(_, _, _, _):
            return .POST
        case .deleteTransaction(_):
            return .DELETE
        case .addTagsToTransaction(_, _):
            return .POST
        case .addTransactionToBudgetCategory(_, _):
            return .POST
        }
    }
    
    var addAuthorizationToken: Bool {
        true
    }
}
