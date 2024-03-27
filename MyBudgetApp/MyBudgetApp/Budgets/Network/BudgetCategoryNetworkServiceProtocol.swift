//
//  BudgetCategoryNetworkServiceProtocol.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 11/12/23.
//

import Foundation

protocol BudgetCategoryNetworkServiceProtocol {
    func getBudgetCategories(from budget: Budget) async -> [BudgetCategory]
    func getBudgetCategoryTransactions(id: BudgetCategory.ID) async -> [Transaction]
    func createBudgetCategory(for budget: Budget, title: String, maxAmount: Double) async -> BudgetCategory?
    func deleteBudgetCategory(id: UUID) async -> Bool
}
