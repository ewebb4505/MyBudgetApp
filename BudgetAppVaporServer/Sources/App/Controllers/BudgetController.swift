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
        let tags = routes.grouped("budgets")
        tags.get(use: getBudgets)
        tags.post(use: createBudget)
        tags.delete(use: deleteBudget)
        
        let tag = routes.grouped("budget")
        tag.get(use: getBudget)
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
        let budget = try req.content.decode(Budget.self)
        try await budget.save(on: req.db)
        return budget
    }
    
    //TODO: I don't think this works right. It's always getting the first element in the table
    func deleteBudget(req: Request) async throws -> HTTPStatus {
        let id = UUID(uuidString: (req.query["id"] ?? "").replacingOccurrences(of: "\"", with: ""))
        req.logger.info("Requested ID: \(String(describing: id?.uuidString))")
        guard let requestedBudget = try await Budget.query(on: req.db).with(\.$categories).first() else {
            throw Abort(.notFound)
        }
        
        // delete the budget categories from this budget
        for category in requestedBudget.categories {
            do {
                try await BudgetCategory.query(on: req.db).filter(\.$id == category.requireID())
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
