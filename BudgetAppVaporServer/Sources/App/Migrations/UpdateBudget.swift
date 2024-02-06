//
//  UpdateBudget.swift
//
//
//  Created by Evan Webb on 2/5/24.
//

import Foundation
import Fluent

struct UpdateBudget: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("budgets")
            .field("userID", .uuid)
            .update()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("budgets")
            .deleteField("userID")
            .update()
    }
}
