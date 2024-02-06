//
//  BudgetCategory.swift
//
//
//  Created by Evan Webb on 10/12/23.
//

import Vapor
import Fluent

final class BudgetCategory: Model, Content {
    static let schema = "budgetCategories"
    
    @ID(key: .id)
    var id: UUID?
    
    @OptionalParent(key: "userID")
    var user: User?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "maxAmount")
    var maxAmount: Double
    
    @Parent(key: "budgetID")
    var budget: Budget
    
    @Children(for: \.$category)
    var transactions: [Transaction]
    
    init() {}
    
    init(id: UUID? = nil,
         userID: User.IDValue,
         title: String,
         maxAmount: Double,
         budget: Budget.IDValue) {
        self.id = id
        self.$user.id = userID
        self.title = title
        self.maxAmount = maxAmount
        self.$budget.id = budget
    }
}
