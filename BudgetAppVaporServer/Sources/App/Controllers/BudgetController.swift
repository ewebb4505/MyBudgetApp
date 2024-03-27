//
//  BudgetController.swift
//
//
//  Created by Evan Webb on 10/12/23.
//

import Foundation
import FluentKit
import Fluent
import Vapor

struct BudgetController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let budgets = routes.grouped("budgets")
        let tokenProtectedBudgetsRoutes = budgets.grouped(Token.authenticator())
        tokenProtectedBudgetsRoutes.get(use: getBudgets)
        tokenProtectedBudgetsRoutes.post(use: createBudget)
        tokenProtectedBudgetsRoutes.delete(use: deleteBudget)
        
        let budget = routes.grouped("budget")
        let tokenProtectedBudgetRoutes = budget.grouped(Token.authenticator())
        tokenProtectedBudgetRoutes.get(use: getBudget)
    }
    
    // Works
    func getBudgets(req: Request) async throws -> [Budget] {
        let isActiveParam = req.query["active"] ?? ""
        let isActive = Bool(isActiveParam)
        if let isActive {
            return try await Budget.query(on: req.db)
                .with(\.$categories)
                .all()
        } else {
            return try await Budget.query(on: req.db)
                .filter(\.$endDate >= Date.now)
                .sort(\.$endDate)
                .with(\.$categories)
                .all()
        }
        
    }
    
    // Works
    func createBudget(req: Request) async throws -> Budget {
        guard let user = try? req.auth.require(User.self), let userID = user.id else {
            throw Abort(.badRequest, reason: "could not find user id.")
        }
        
        let budgetRequest = try req.content.decode(CreateBudgetRequestObject.self)
        let budget = try Budget(userID: user.requireID(),
                                title: budgetRequest.title,
                                startDate: budgetRequest.startDate,
                                endDate: budgetRequest.endDate,
                                startingAmount: budgetRequest.startingAmount)
        
        try await budget.save(on: req.db)
        print("\n\n\n\(budget.description)\n\n\n")
        return budget
    }
    
    //TODO: I don't think this works right. It's always getting the first element in the table
    func deleteBudget(req: Request) async throws -> HTTPStatus {
        guard let user = try? req.auth.require(User.self), let userID = user.id else {
            throw Abort(.badRequest, reason: "could not find user id.")
        }
        
        let id = UUID(uuidString: (req.query["id"] ?? "").replacingOccurrences(of: "\"", with: ""))
        req.logger.info("Requested ID: \(String(describing: id?.uuidString))")
        
        guard let requestedBudget = try await Budget.query(on: req.db)
            .filter(\.$user.$id == userID)
            .with(\.$categories)
            .first() else {
            throw Abort(.notFound)
        }
        
        // delete the budget categories from this budget
        for category in requestedBudget.categories {
            do {
                try await BudgetCategory.query(on: req.db)
                    .filter(\.$user.$id == userID)
                    .filter(\.$id == category.requireID())
                    .all()
                    .delete(on: req.db)
            }
            catch {
                throw Abort(.notFound, reason: "category not found from budget category list")
            }
        }
        
        try await requestedBudget.delete(on: req.db)
        return .ok
    }
    
    // works
    func getBudget(req: Request) async throws -> Budget {
        let id = UUID(uuidString: (req.query["id"] ?? "").replacingOccurrences(of: "\"", with: ""))
        req.logger.info("Requested ID: \(String(describing: id?.uuidString))")
        guard let budget = try await Budget.query(on: req.db).with(\.$categories).first() else {
            throw Abort(.notFound)
        }
        return budget
    }
}

struct CreateBudgetRequestObject: Content {
    var title: String
    var startDate: Date
    var endDate: Date
    var startingAmount: Double
}
