//
//  UpdateTag.swift
//
//
//  Created by Evan Webb on 2/5/24.
//

import Foundation
import Fluent

struct UpdateTag: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("tags")
            .field("userID", .uuid)
            .update()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("tags")
            .deleteField("userID")
            .update()
    }
}
