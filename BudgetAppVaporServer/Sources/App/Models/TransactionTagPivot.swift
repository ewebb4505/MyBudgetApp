//
//  File.swift
//  
//
//  Created by Evan Webb on 10/4/23.
//

import Vapor
import Fluent

final class TransactionTagPivot: Model {
    static let schema = "transactions-tags-pivot"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "transactionID")
    var transaction: Transaction
      
    @Parent(key: "tagID")
    var tag: Tag
    
    init() {}
    
    init(id: UUID? = nil, transaction: Transaction, tag: Tag) throws {
        self.id = id
        self.$transaction.id = try transaction.requireID()
        self.$tag.id = try tag.requireID()
    }
}
