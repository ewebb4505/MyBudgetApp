//
//  BudgetCategorySearchable.swift
//  BudgetApp
//
//  Created by Evan Webb on 10/31/23.
//

import Foundation

protocol BudgetCategorySearchable {
    func getBudgetCategories(from budget: Budget) async -> [BudgetCategory]
    func createBudgetCategory(for budget: Budget, title: String, maxAmount: Double) async -> BudgetCategory?
    func deleteBudgetCategory(id: UUID) async -> Bool
}
