//
//  UpdateTransactionTagPivot.swift
//
//
//  Created by Evan Webb on 10/6/23.
//

import Foundation
import Fluent

struct UpdateTransactionTagPivot: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("transactions-tags-pivot")
            .delete()
    }

    func revert(on database: Database) async throws {
        try await database.schema("transactions-tags-pivot").delete()
    }
}
