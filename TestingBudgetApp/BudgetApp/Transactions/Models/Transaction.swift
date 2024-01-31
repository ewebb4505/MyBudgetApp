//
//  Transaction.swift
//  BudgetApp
//
//  Created by Evan Webb on 10/1/23.
//

import Foundation

struct Transaction: Codable, Identifiable {
    var id: UUID
    var title: String
    var amount: Double
    var date: Date
    var tags: [Tag]?
}
