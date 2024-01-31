//
//  CreateBudgetCategory.swift
//
//
//  Created by Evan Webb on 10/12/23.
//

import Foundation
import Fluent

struct CreateBudgetCategory: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("budgetCategories")
            .id()
            .field("title", .string, .required)
            .field("maxAmount", .double, .required)
            .field("budgetID", .uuid, .references("budgets", "id"))
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("budgetCategories").delete()
    }
}
