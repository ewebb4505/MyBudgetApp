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
    
    func createBudget(title: String, startDate: Date, endDate: Date, amount: Double) async -> Budget? {
        let requestData = BudgetRequest.createBudget(title, startDate, endDate, amount)
        do {
          let budget: Budget? = try await requestManager.perform(requestData)
          return budget
        } catch let DecodingError.dataCorrupted(context) {
            print(context)
            return nil
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            return nil
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            return nil
        } catch let DecodingError.typeMismatch(type, context)  {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
            return nil
        } catch {
            print("error: ", error)
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
