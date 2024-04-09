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
    var transactions: [Transaction]?
    
    var totalAmountSpent: Double {
        guard let transactions else {
            return 0
        }
        let amount: Double = transactions.reduce(0, { $0 + $1.amount })
        return amount
    }
}

struct BudgetID: Codable, Hashable, Identifiable {
    var id: UUID
}
