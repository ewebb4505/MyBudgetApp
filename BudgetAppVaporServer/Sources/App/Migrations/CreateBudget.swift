//
//  CreateBudget.swift
//
//
//  Created by Evan Webb on 10/12/23.
//

import Foundation
import Fluent

struct CreateBudget: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("budgets")
            .id()
            .field("title", .string, .required)
            .field("startDate", .date, .required)
            .field("endDate", .date, .required)
            .unique(on: "startDate", "endDate")
            .field("startingAmount", .double, .required)
            .create()
        
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("budgets").delete()
    }
}
