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
        tokenProtected.post(use: createBudgetCategory)
        tokenProtected.delete(use: deleteBudgetCategory)
    }
    
    // works but sends back budget id
    func getAllCategoriesForABudget(req: Request) async throws -> [BudgetCategory] {
        let budgetID = UUID(uuidString: (req.query["id"] ?? "").replacingOccurrences(of: "\"", with: ""))
        guard let budgetID else {
            throw Abort(.badRequest)
        }
        
        guard let budget = try await Budget.query(on: req.db).with(\.$categories).filter(\.$id == budgetID).first() else {
            throw Abort(.notFound)
        }
        
        return budget.categories
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
    
    
}

struct CreateBudgetCategoryRequest: Content {
    var budgetID: String
    var title: String
    var maxAmount: Double
}


