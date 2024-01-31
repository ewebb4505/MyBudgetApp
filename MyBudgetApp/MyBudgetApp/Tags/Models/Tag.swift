//
//  Tag.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 11/12/23.
//

import Foundation

struct Tag: Codable, Identifiable {
    var id: UUID
    var title: String
}
