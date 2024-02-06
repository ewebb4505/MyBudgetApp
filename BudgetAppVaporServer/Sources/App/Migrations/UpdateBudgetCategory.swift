//
//  UpdateCategoryController.swift
//
//
//  Created by Evan Webb on 2/5/24.
//

import Foundation
import Fluent

struct UpdateBudgetCategory: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("budgetCategories")
            .field("userID", .uuid)
            .update()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("budgetCategories")
            .deleteField("userID")
            .update()
    }
}
