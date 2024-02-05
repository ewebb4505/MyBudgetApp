//
//  UpdateTransactionV3.swift
//
//
//  Created by Evan Webb on 2/5/24.
//

import Foundation
import Fluent

struct UpdateTransactionV3: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("transactions")
            .field("userID", .uuid)
            .update()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("transactions")
            .deleteField("userID")
            .update()
    }
}
