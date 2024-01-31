//
//  Tag.swift
//  BudgetApp
//
//  Created by Evan Webb on 10/9/23.
//

import Foundation

struct Tag: Codable, Identifiable {
    var id: UUID
    var title: String
}
