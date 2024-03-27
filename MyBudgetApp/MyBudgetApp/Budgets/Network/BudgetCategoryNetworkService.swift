//
//  BudgetCategoryNetworkService.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 11/12/23.
//

import Foundation

class BudgetCategoryService: BudgetCategoryNetworkServiceProtocol {
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
    
    func getBudgetCategoryTransactions(id: BudgetCategory.ID) async -> [Transaction] {
        let requestData = BudgetCategoryRequest.getBudgetCategoryTransactions(id)
        do {
          let transactions: [Transaction] = try await requestManager.perform(requestData)
          return transactions
        } catch let DecodingError.dataCorrupted(context) {
            print(context)
            return []
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            return []
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            return []
        } catch let DecodingError.typeMismatch(type, context)  {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
            return []
        } catch {
            print("error: ", error)
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
