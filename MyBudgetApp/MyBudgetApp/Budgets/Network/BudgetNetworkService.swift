//
//  BudgetNetworkService.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 11/12/23.
//

import Foundation

struct BudgetNetworkService: BudgetNetworkServiceProtocol {
    let requestManager: RequestManagerProtocol
    
    func getBudgets(isActive: Bool) async -> [Budget] {
        let requestData = BudgetRequest.getBudgets(isActive)
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
