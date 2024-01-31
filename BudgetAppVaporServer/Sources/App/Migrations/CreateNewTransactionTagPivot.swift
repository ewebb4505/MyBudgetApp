//
//  CreateNewTransactionTagPivot.swift
//  
//
//  Created by Evan Webb on 10/6/23.
//

import Foundation
import Fluent

struct CreateNewTransactionTagPivot: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("transactions-tags-pivot")
            .id()
            .field("transactionID", .uuid, .required, .references("transactions", "id"))
            .field("tagID", .uuid, .required, .references("tags", "id"))
            .unique(on: "transactionID", "tagID")
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("transactions-tags-pivot").delete()
    }
}
