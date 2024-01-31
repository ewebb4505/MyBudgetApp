//
//  CreateTransaction.swift
//
//
//  Created by Evan Webb on 9/28/23.
//

import Foundation
import Fluent

struct CreateTransaction: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("transactions")
            .id()
            .field("title", .string, .required)
            .field("amount", .double, .required)
            .field("date", .date, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("transactions").delete()
    }
}
