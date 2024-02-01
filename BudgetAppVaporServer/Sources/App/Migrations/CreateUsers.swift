//
//  CreateUser.swift
//
//
//  Created by Evan Webb on 1/31/24.
//

import Fluent

struct CreateUsers: AsyncMigration {
  func prepare(on database: Database) async throws {
      try await database.schema(User.schema)
          .id()
      //.field("id", .uuid, .identifier(auto: true))
      .field("username", .string, .required)
      .unique(on: "username")
      .field("password_hash", .string, .required)
      .field("created_at", .datetime, .required)
      .field("updated_at", .datetime, .required)
      .create()
  }

  func revert(on database: Database) async throws {
      try await database.schema(User.schema).delete()
  }
}
