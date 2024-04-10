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
        let budgets: [Budget] = await verboseNetworkCall(returnFromCatch: [], 
                                                         perform: try await requestManager.perform(requestData))
        return budgets
    }
    
    func getBudget(id: UUID) async -> Budget? {
        let requestData = BudgetRequest.getBudget(id)
        let budgets: Budget? = await verboseNetworkCall(returnFromCatch: nil,
                                                         perform: try await requestManager.perform(requestData))
        return budgets
    }
    
    func createBudget(title: String, startDate: Date, endDate: Date, amount: Double) async -> Budget? {
        let requestData = BudgetRequest.createBudget(title, startDate, endDate, amount)
        let budget: Budget? = await verboseNetworkCall(returnFromCatch: nil,
                                                         perform: try await requestManager.perform(requestData))
        return budget
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
