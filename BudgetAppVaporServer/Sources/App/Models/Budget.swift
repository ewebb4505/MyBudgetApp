//
//  Budget.swift
//
//
//  Created by Evan Webb on 10/12/23.
//

import Vapor
import Fluent

final class Budget: Model, Content {
    static let schema = "budgets"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "startDate")
    var startDate: Date
    
    @Field(key: "endDate")
    var endDate: Date
    
    @Field(key: "startingAmount")
    var startingAmount: Double
    
    @Children(for: \.$budget)
    var categories: [BudgetCategory]

    init() {}
    
    init(id: UUID? = nil,
         title: String,
         startDate: Date,
         endDate: Date,
         startingAmount: Double) {
        self.id = id
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.startingAmount = startingAmount
    }
}
