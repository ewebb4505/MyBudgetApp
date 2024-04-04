//
//  BudgetCategoryController.swift
//
//
//  Created by Evan Webb on 10/12/23.
//

import Foundation
import FluentKit
import Fluent
import Vapor

struct BudgetCategoryController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let routes = routes.grouped("categories")
        let tokenProtected = routes.grouped(Token.authenticator())
        tokenProtected.get(use: getAllCategoriesForABudget)
        tokenProtected.get("transactions", use: getAllTransactionsForBudetCategory)
        tokenProtected.post(use: createBudgetCategory)
        tokenProtected.delete(use: deleteBudgetCategory)
        
        // fix this crap
        let anotherRoute = routes.grouped("x")
        let tokenProtected2 = anotherRoute.grouped(Token.authenticator())
        tokenProtected2.post(use: addTransactionToCategroy)
    }
    
    // works but sends back budget id
    func getAllCategoriesForABudget(req: Request) async throws -> [BudgetCategory] {
        let budgetID = UUID(uuidString: (req.query["id"] ?? "").replacingOccurrences(of: "\"", with: ""))
        guard let budgetID else {
            throw Abort(.badRequest)
        }
        
        guard let budget = try await Budget.query(on: req.db)
            .with(\.$categories)
            .filter(\.$id == budgetID)
            .first() else {
            throw Abort(.notFound)
        }
        
        return budget.categories
    }
    
    func getAllTransactionsForBudetCategory(req: Request) async throws -> [Transaction] {
        guard let user = try? req.auth.require(User.self), let userID = user.id else {
            throw Abort(.badRequest, reason: "could not find user id.")
        }
        
        let budgetCategoryID = UUID(uuidString: (req.query["id"] ?? "").replacingOccurrences(of: "\"", with: ""))
        if let budgetCategoryID {
            guard let budgetCategory = try await BudgetCategory.query(on: req.db)
                .filter(\.$user.$id == userID)
                .filter(\.$id == budgetCategoryID)
                .with(\.$transactions)
                .first() else {
                throw Abort(.badRequest, reason: "could not find budget category")
            }
            
            return budgetCategory.transactions
        } else {
            throw Abort(.badRequest, reason: "could not create budget category id")
        }
    }
    
    // works
    func createBudgetCategory(req: Request) async throws -> BudgetCategory {
        guard let user = try? req.auth.require(User.self), let userID = user.id else {
            throw Abort(.badRequest, reason: "could not find user id.")
        }
        // first find the budget with the budget id from the request
        let budgetCategoryRequest = try req.content.decode(CreateBudgetCategoryRequest.self)
        let budgetID = UUID(uuidString: (budgetCategoryRequest.budgetID).replacingOccurrences(of: "\"", with: ""))
        // then create the BudgetCategory object and save to the database.
        
        if let budgetID {
            guard let budget = try await Budget.find(budgetID, on: req.db) else { throw Abort(.notFound) }
            let budgetCategory = try BudgetCategory(userID: userID, 
                                                    title: budgetCategoryRequest.title,
                                                    maxAmount: budgetCategoryRequest.maxAmount,
                                                    budget: budget.requireID())
            try await budgetCategory.save(on: req.db)
            return budgetCategory
        } else {
            throw Abort(.badRequest, reason: "could not find budget")
        }
    }
    
    // works
    func deleteBudgetCategory(req: Request) async throws -> HTTPStatus {
        let budgetCategoryID = UUID(uuidString: (req.query["id"] ?? "").replacingOccurrences(of: "\"", with: ""))
        let budgetCategory = try await BudgetCategory.find(budgetCategoryID, on: req.db)
        guard let budgetCategory else {
            throw Abort(.badRequest, reason: "could not find budget")
        }
        
        try await budgetCategory.delete(on: req.db)
        return .ok
    }
    
    // works but it would be nice to have the category object returned as well.
    func addTransactionToCategroy(req: Request) async throws -> Transaction {
        guard let user = try? req.auth.require(User.self), let userID = user.id else {
            throw Abort(.badRequest, reason: "could not find user id.")
        }
        
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

struct CreateBudgetCategoryRequest: Content {
    var budgetID: String
    var title: String
    var maxAmount: Double
}


