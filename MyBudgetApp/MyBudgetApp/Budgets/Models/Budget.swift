//
//  Budget.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 11/12/23.
//

import Foundation

struct Budget: Codable, Identifiable {
    var id: UUID
    var title: String
    var startDate: Date
    var endDate: Date
    var startingAmount: Double
    var categories: [BudgetCategory]
}
