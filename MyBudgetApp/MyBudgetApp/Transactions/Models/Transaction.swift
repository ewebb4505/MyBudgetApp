//
//  Transaction.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 11/12/23.
//

import Foundation

struct Transaction: Codable, Hashable, Identifiable {
    var id: UUID
    var title: String
    var amount: Double
    var date: Date
    var tags: [Tag]?
}
