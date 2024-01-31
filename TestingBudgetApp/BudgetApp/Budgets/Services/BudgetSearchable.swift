//
//  BudgetSearchable.swift
//  BudgetApp
//
//  Created by Evan Webb on 10/25/23.
//

import Foundation

protocol BudgetSearchable {
    func getBudgets() async -> [Budget]
    func createBudget(title: String, startDate: Date, endDate: Date, amount: Double) async -> Budget?
    func deleteBudget(id: UUID) async -> Bool
}
