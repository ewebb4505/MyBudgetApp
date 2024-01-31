//
//  UpdateTransaction.swift
//
//
//  Created by Evan Webb on 10/12/23.
//

import Foundation
import Fluent

struct UpdateTransaction: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("transactions")
            .field("budgetCategory", .uuid, .references("budgetCategories", "id"))
            .update()
        
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("transactions")
            .deleteField("budgetCategory")
            .update()
    }
}
