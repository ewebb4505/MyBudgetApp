//
//  Tag.swift
//
//
//  Created by Evan Webb on 10/4/23.
//

import Vapor
import Fluent

final class Tag: Model, Content {
    static let schema = "tags"
    
    @ID(key: .id)
    var id: UUID?
    
    @OptionalParent(key: "userID")
    var user: User?
    
    @Field(key: "title")
    var title: String
    
    @Siblings(through: TransactionTagPivot.self,
              from: \.$tag,
              to: \.$transaction)
    var tags: [Transaction]

    init() {}
    
    init(id: UUID? = nil, 
         userID: User.IDValue,
         title: String) {
        self.id = id
        self.$user.id = userID
        self.title = title
    }
}
