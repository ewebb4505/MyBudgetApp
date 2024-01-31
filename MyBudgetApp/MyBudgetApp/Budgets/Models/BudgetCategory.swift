//
//  BudgetCategory.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 11/12/23.
//

import Foundation

struct BudgetCategory: Codable, Identifiable, Hashable {
    var id: UUID
    var title: String
    var maxAmount: Double
    var budget: BudgetID
}

struct BudgetID: Codable, Hashable, Identifiable {
    var id: UUID
}
