//
//  CreateTransactionTagPivot.swift
//  
//
//  Created by Evan Webb on 10/4/23.
//

import Foundation
import Fluent

struct CreateTransactionTagPivot: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("transactions-tags-pivot")
            .id()
            .field("transactionID", .uuid, .required)
            .field("tagID", .uuid, .required)
            .unique(on: "transactionID", "tagID")
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("transactions-tags-pivot").delete()
    }
}
