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
    
    @OptionalParent(key: "userID")
    var user: User?
    
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
         userID: User.IDValue,
         title: String,
         startDate: Date,
         endDate: Date,
         startingAmount: Double) {
        self.id = id
        self.$user.id = userID
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.startingAmount = startingAmount
    }
}
