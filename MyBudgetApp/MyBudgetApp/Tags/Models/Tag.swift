//
//  Tag.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 11/12/23.
//

import Foundation
import Charts

struct Tag: Codable, Hashable, Identifiable {
    var id: UUID
    var title: String
    var totalAmountTracked: Double?
}
