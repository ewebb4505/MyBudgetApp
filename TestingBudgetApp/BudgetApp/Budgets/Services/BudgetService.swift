//
//  BudgetService.swift
//  BudgetApp
//
//  Created by Evan Webb on 10/25/23.
//

import Foundation

struct BudgetService: BudgetSearchable {
    let requestManager: RequestManagerProtocol
    
    func getBudgets() async -> [Budget] {
        let requestData = BudgetRequest.getBudgets
        do {
          let budgets: [Budget] = try await requestManager.perform(requestData)
          return budgets
        } catch {
          print(error.localizedDescription)
          return []
        }
    }
    
    func createBudget(title: String, startDate: Date, endDate: Date, amount: Double) async -> Budget? {
        let requestData = BudgetRequest.createBudget(title, startDate, endDate, amount)
        do {
          let budget: Budget? = try await requestManager.perform(requestData)
          return budget
        } catch {
          print(error.localizedDescription)
          return nil
        }
    }
    
    func deleteBudget(id: UUID) async -> Bool {
        let requestData = BudgetRequest.deleteBudget(id)
        do {
            try await requestManager.performWithNoParsing(requestData)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}
