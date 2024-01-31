//
//  CreateTag.swift
//  
//
//  Created by Evan Webb on 10/4/23.
//

import Foundation
import Fluent

struct CreateTag: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("tags")
            .id()
            .field("title", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("tags").delete()
    }
}
