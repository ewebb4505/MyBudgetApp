//
//  UpdateTransactionTagPivotV2.swift
//
//
//  Created by Evan Webb on 3/21/24.
//

import Foundation
import Fluent

struct UpdateTransactionTagPivotV2: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("transactions-tags-pivot")
            .field("userID", .uuid)
            .update()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("transactions-tags-pivot")
            .deleteField("userID")
            .update()
    }
}
