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
    func getBudgets(req: Request) async throws -> [GetBudgetResponseObject] {
        guard let user = try? req.auth.require(User.self), let userID = user.id else {
            throw Abort(.badRequest, reason: "could not find user id.")
        }
        
        let isActiveParam = req.query["active"] ?? ""
        let isActive = Bool(isActiveParam)
        
        var budgets: [Budget] = []
        if let isActive {
            budgets = try await Budget.query(on: req.db)
                .with(\.$categories)
                .all()
        } else {
            budgets = try await Budget.query(on: req.db)
                .filter(\.$endDate >= Date.now)
                .sort(\.$endDate)
                .with(\.$categories)
                .all()
        }
        
        var budgetsResponseObj: [GetBudgetResponseObject] = []
        for budget in budgets {
            let transactions: [Transaction]? = try? await Transaction.query(on: req.db)
                    .filter(\.$user.$id == userID)
                    .with(\.$category)
                    .with(\.$tags)
                    .filter(\.$date <= budget.endDate)
                    .filter(\.$date >= budget.startDate)
                    .all()
            
            var budgetResponseObj: GetBudgetResponseObject
            
            if let transactions {
                let totalSpent: Double = transactions.reduce(into: 0.0) { partialResult, transaction in
                    partialResult += transaction.amount
                }
                
                let unassignedTransactions = transactions.filter { $0.category == nil }
                
                budgetResponseObj = .init(id: try budget.requireID(),
                                          title: budget.title,
                                          startDate: budget.startDate,
                                          endDate: budget.endDate,
                                          startingAmount: budget.startingAmount,
                                          categories: budget.categories,
                                          totalSpent: totalSpent,
                                          unassignedTransactions: unassignedTransactions)
                
            } else {
                budgetResponseObj = .init(id: try budget.requireID(),
                                          title: budget.title,
                                          startDate: budget.startDate,
                                          endDate: budget.endDate,
                                          startingAmount: budget.startingAmount,
                                          categories: budget.categories,
                                          totalSpent: 0.0)
                
            }
            
            budgetsResponseObj.append(budgetResponseObj)

        }
        
        return budgetsResponseObj
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
    func getBudget(req: Request) async throws -> GetBudgetResponseObject {
        guard let user = try? req.auth.require(User.self), let userID = user.id else {
            throw Abort(.badRequest, reason: "could not find user id.")
        }
        
        let id = UUID(uuidString: (req.query["id"] ?? "").replacingOccurrences(of: "\"", with: ""))
        req.logger.info("Requested ID: \(String(describing: id?.uuidString))")
        
        guard let budget = try await Budget.query(on: req.db)
            .filter(\.$user.$id == userID)
            .with(\.$categories)
            .first() else {
            throw Abort(.notFound)
        }
        
        // get all unassigned transactions from this the start date to the end date for this budget
        let transactions: [Transaction]? = try? await Transaction.query(on: req.db)
                .filter(\.$user.$id == userID)
                .with(\.$category)
                .with(\.$tags)
                .filter(\.$date <= budget.endDate)
                .filter(\.$date >= budget.startDate)
                .all()
        
        var budgetResponseObj: GetBudgetResponseObject
        
        if let transactions {
            let totalSpent: Double = transactions.reduce(into: 0.0) { partialResult, transaction in
                partialResult += transaction.amount
            }
            
            let unassignedTransactions = transactions.filter { $0.category == nil }
            
            budgetResponseObj = .init(id: try budget.requireID(),
                                      title: budget.title,
                                      startDate: budget.startDate,
                                      endDate: budget.endDate,
                                      startingAmount: budget.startingAmount,
                                      categories: budget.categories,
                                      totalSpent: totalSpent,
                                      unassignedTransactions: unassignedTransactions)
            
        } else {
            budgetResponseObj = .init(id: try budget.requireID(),
                                      title: budget.title,
                                      startDate: budget.startDate,
                                      endDate: budget.endDate,
                                      startingAmount: budget.startingAmount,
                                      categories: budget.categories, 
                                      totalSpent: 0.0)
            
        }
        
        return budgetResponseObj
    }
}

struct CreateBudgetRequestObject: Content {
    var title: String
    var startDate: Date
    var endDate: Date
    var startingAmount: Double
}

struct GetBudgetResponseObject: Content {
    var id: Budget.IDValue
    var title: String
    var startDate: Date
    var endDate: Date
    var startingAmount: Double
    var categories: [BudgetCategory]?
    var totalSpent: Double
    var unassignedTransactions: [Transaction]?
}
