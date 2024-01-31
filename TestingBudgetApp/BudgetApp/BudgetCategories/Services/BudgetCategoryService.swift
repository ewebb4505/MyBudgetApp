//
//  BudgetCategoryService.swift
//  BudgetApp
//
//  Created by Evan Webb on 10/31/23.
//

import Foundation

class BudgetCategoryService: BudgetCategorySearchable {
    let requestManager: RequestManagerProtocol
    
    init(requestManager: RequestManagerProtocol) {
        self.requestManager = requestManager
    }
    
    func getBudgetCategories(from budget: Budget) async -> [BudgetCategory] {
        let requestData = BudgetCategoryRequest.getBudgetCategories(budget.id)
        do {
          let budgets: [BudgetCategory] = try await requestManager.perform(requestData)
          return budgets
        } catch {
          print(error.localizedDescription)
          return []
        }
    }
    
    func createBudgetCategory(for budget: Budget, 
                              title: String,
                              maxAmount: Double) async -> BudgetCategory? {
        let requestData = BudgetCategoryRequest.createBudgetCategory(budget.id, title, maxAmount)
        do {
          let budget: BudgetCategory? = try await requestManager.perform(requestData)
          return budget
        } catch {
          print(error.localizedDescription)
          return nil
        }
    }
    
    func deleteBudgetCategory(id: UUID) async -> Bool {
        let requestData = BudgetCategoryRequest.deleteBudgetCategory(id)
        do {
            try await requestManager.performWithNoParsing(requestData)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}
