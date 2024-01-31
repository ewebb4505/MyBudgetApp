//
//  BudgetNetworkServiceProtocol.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 11/12/23.
//

import Foundation

protocol BudgetNetworkServiceProtocol {
    func getBudgets(isActive: Bool) async -> [Budget]
    func createBudget(title: String, startDate: Date, endDate: Date, amount: Double) async -> Budget?
    func deleteBudget(id: UUID) async -> Bool
}
