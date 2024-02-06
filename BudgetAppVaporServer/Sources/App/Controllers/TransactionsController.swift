//
//  TransactionsController.swift
//
//
//  Created by Evan Webb on 10/4/23.
//

import Foundation
import Fluent
import FluentKit
import Vapor

struct TransactionsController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let transactions = routes.grouped("transactions")
        let tokenProtected = transactions.grouped(Token.authenticator())
        tokenProtected.get(use: getTransactions)
        tokenProtected.post(use: createTransaction)
        tokenProtected.delete(use: deleteTransaction)
        tokenProtected.post("transactions", "budget", "category", use: addTransactionToCategroy)
    }
    
    // TESTING (Nov 13)
    func getTransactions(req: Request) async throws -> [Transaction] {
        guard let user = try? req.auth.require(User.self), let userID = user.id else {
            throw Abort(.badRequest, reason: "could not find user id.")
        }
        
        // if "n" query param is present then get that number of results
        let nParam: Int? = Int(req.query["n"] ?? "")
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let fromParam: String = req.query["fromDate"] ?? ""
        let toParam: String = req.query["toDate"] ?? ""
        let from = formatter.date(from: fromParam)
        req.logger.debug("FROM_DATE: \(String(describing: from)) from \(fromParam)")
        let to = formatter.date(from: toParam)
        req.logger.debug("TO_DATE: \(String(describing: to)) to \(toParam)")
        let on = formatter.date(from: req.query["onDate"] ?? "")
        req.logger.debug("ON_DATE: \(String(describing: on))")
        
        //TODO: please refactor this before finishing
        if let on {
            if let nParam {
                return try await Transaction.query(on: req.db)
                    .filter(\.$user.$id == userID)
                    .filter(\.$date == on)
                    .with(\.$tags)
                    .range(..<nParam)
                    .all()
            } else {
                return try await Transaction.query(on: req.db)
                    .filter(\.$user.$id == userID)
                    .filter(\.$date == on)
                    .with(\.$tags)
                    .all()
            }
        } else if let from, let to {
            if let nParam {
                return try await Transaction.query(on: req.db)
                    .filter(\.$user.$id == userID)
                    .filter(\.$date <= to)
                    .filter(\.$date >= from)
                    .with(\.$tags)
                    .range(..<nParam)
                    .all()
            } else {
                return try await Transaction.query(on: req.db)
                    .filter(\.$user.$id == userID)
                    .filter(\.$date <= to)
                    .filter(\.$date >= from)
                    .with(\.$tags)
                    .all()
            }
        } else if let from {
            if let nParam {
                return try await Transaction.query(on: req.db)
                    .filter(\.$user.$id == userID)
                    .filter(\.$date >= from)
                    .with(\.$tags)
                    .range(..<nParam)
                    .all()
            } else {
                return try await Transaction.query(on: req.db)
                    .filter(\.$user.$id == userID)
                    .filter(\.$date >= from)
                    .with(\.$tags)
                    .all()
            }
        } else if let to {
            if let nParam {
                return try await Transaction.query(on: req.db)
                    .filter(\.$user.$id == userID)
                    .filter(\.$date <= to)
                    .with(\.$tags)
                    .range(..<nParam)
                    .all()
            } else {
                return try await Transaction.query(on: req.db)
                    .filter(\.$user.$id == userID)
                    .filter(\.$date <= to)
                    .with(\.$tags)
                    .all()
            }
        } else {
            if let nParam {
                return try await Transaction.query(on: req.db)
                    .filter(\.$user.$id == userID)
                    .with(\.$tags)
                    .range(..<nParam)
                    .all()
            } else {
                return try await Transaction.query(on: req.db)
                    .filter(\.$user.$id == userID)
                    .with(\.$tags)
                    .all()
            }
        }
    }
    
    func createTransaction(req: Request) async throws -> Transaction {
        let user = try req.auth.require(User.self)
        
        guard let userID = try? user.requireID() else {
            throw Abort(.badRequest, reason: "userID not found")
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let transactionRequest = try req.content.decode(CreateTransactionRequest.self)
        // figure out a better way of handling this
        guard let transactionRequestDate = formatter.date(from: transactionRequest.date) else {
            throw Abort(.badRequest, reason: "bad date string given")
        }
        let transaction = Transaction(userID: userID,
                                      title: transactionRequest.title, 
                                      amount: transactionRequest.amount,
                                      date: transactionRequestDate)
        try await transaction.save(on: req.db)
        
        for tag in transactionRequest.tags {
            let id = UUID(uuidString: (tag ?? "").replacingOccurrences(of: "\"", with: ""))
            guard let tag = try await Tag.find(id, on: req.db) else {
                throw Abort(.notFound, reason: "Tag ID \(tag) Not Found In Tags Table")
            }
            try await TransactionTagPivot(transaction: transaction, tag: tag).save(on: req.db)
        }
        
        return transaction
    }
    
    // works (Oct, 27)
    func deleteTransaction(req: Request) async throws -> HTTPStatus {
        guard let user = try? req.auth.require(User.self), let userID = user.id else {
            throw Abort(.badRequest, reason: "could not find user id.")
        }
        
        let id = UUID(uuidString: (req.query["id"] ?? "").replacingOccurrences(of: "\"", with: ""))
        req.logger.info("Requested ID: \(String(describing: id?.uuidString))")
        guard let transaction = try await Transaction.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "ID not found")
        }
        try await transaction.delete(on: req.db)
        return .ok
    }
    
    // works but it would be nice to have the category object returned as well.
    func addTransactionToCategroy(req: Request) async throws -> Transaction {
        let addTransactionToBudgetCategoryRequest = try req.content.decode(AddTransactionToBudgetCategory.self)
        let budgetCategoryID = UUID(uuidString: (addTransactionToBudgetCategoryRequest.budgetCategoryID).replacingOccurrences(of: "\"", with: ""))
        let transactionID = UUID(uuidString: (addTransactionToBudgetCategoryRequest.transactionID).replacingOccurrences(of: "\"", with: ""))
        
        let budgetCategory = try await BudgetCategory.find(budgetCategoryID, on: req.db)
        let transaction = try await Transaction.find(transactionID, on: req.db)
        
        guard let transaction else {
            throw Abort(.badRequest, reason: "could not find transaction")
        }
        
        guard let budgetCategory else {
            throw Abort(.badRequest, reason: "could not find category")
        }
        
        transaction.$category.id = budgetCategory.id
        
        try await transaction.save(on: req.db)
        
        return transaction
    }
}

struct AddTransactionToBudgetCategory: Content {
    var budgetCategoryID: String
    var transactionID: String
}

// might need this for the create transaction request so I can add tags when creating the transaciton
struct CreateTransactionRequest: Content {
    var title: String
    var amount: Double
    var date: String
    var category: CategoryID
    var tags: [String]
}

struct CategoryID: Content {
    var id: String
}

/*
 "title": "TestingOct27",
 "amount": -999,
 "date": "2023-10-27T03:00:34Z",
 "category": { "id": null }
 */
