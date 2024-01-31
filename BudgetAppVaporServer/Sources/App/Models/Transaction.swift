//
//  Transaction.swift
//
//
//  Created by Evan Webb on 9/28/23.
//

import Vapor
import Fluent

final class Transaction: Model, Content {
    static let schema = "transactions"
    
    @ID(key: .id) 
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "amount")
    var amount: Double
    
    @Field(key: "date")
    var date: Date
    
    @Siblings(through: TransactionTagPivot.self,
              from: \.$transaction,
              to: \.$tag)
    var tags: [Tag]
    
    @OptionalParent(key: "budgetCategory")
    var category: BudgetCategory?
    
    init() {}
    
    init(id: UUID? = nil, 
         title: String,
         amount: Double,
         date: Date,
         tags: [Tag],
         category: BudgetCategory.IDValue){
        self.id = id
        self.title = title
        self.date = date
        self.tags = tags
        self.$category.id = category
    }
    
    init(id: UUID? = nil,
         title: String,
         amount: Double,
         date: Date,
         tags: [Tag]){
        self.id = id
        self.title = title
        self.date = date
        self.tags = tags
    }
    
    init(id: UUID? = nil, 
         title: String,
         amount: Double,
         date: Date) {
        self.id = id
        self.title = title
        self.date = date
        self.tags = []
    }
}
