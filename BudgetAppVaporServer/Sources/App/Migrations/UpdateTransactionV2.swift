//
//  File.swift
//  
//
//  Created by Evan Webb on 10/26/23.
//

import Foundation
import Fluent

struct UpdateTransactionV2: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("transactions")
            .id()
            .field("budgetCategory", .uuid, .references("budgetCategories", "id"))
            .update()
        
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("transactions")
            .deleteField("budgetCategory")
            .update()
    }
}
