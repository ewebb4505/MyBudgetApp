//
//  TransactionTagsController.swift
//
//
//  Created by Evan Webb on 10/6/23.
//

import Foundation
import Fluent
import FluentKit
import Vapor

final class TransactionTagsController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let tokenProtected = routes.grouped(Token.authenticator())
        tokenProtected.get("transaction", "tags", use: getTagsForTransaction)
        tokenProtected.post("transaction", "tags", use: addTagsForTransaction)
    }
    
    func getTagsForTransaction(req: Request) async throws -> [Tag] {
        guard let user = try? req.auth.require(User.self).asPublic() else {
            throw Abort(.badRequest, reason: "could not find user id.")
        }
        
        let id = UUID(uuidString: (req.query["id"] ?? "").replacingOccurrences(of: "\"", with: ""))
        req.logger.info("Requested ID: \(String(describing: id?.uuidString))")
        guard let transaction = try await Transaction.find(id, on: req.db) else {
            throw Abort(.notFound)
        }
        return try await transaction.$tags.get(on: req.db)
    }
    
    func addTagsForTransaction(req: Request) async throws -> Transaction {
        guard let user = try? req.auth.require(User.self).asPublic() else {
            throw Abort(.badRequest, reason: "could not find user id.")
        }
        
        let addTagsToTransaction = try req.content.decode(AddTagsToTransaction.self)
        let id = UUID(uuidString: (addTagsToTransaction.id).replacingOccurrences(of: "\"", with: ""))
        do {
            if let id, let transaction = try await Transaction.find(id, on: req.db) {
                for tag in addTagsToTransaction.tagIDs {
                    guard let tag = try await Tag.find(tag, on: req.db) else {
                        throw Abort(.notFound, reason: "Tag ID \(tag) Not Found In Tags Table")
                    }
                    try await TransactionTagPivot(transaction: transaction,
                                                  tag: tag,
                                                  userID: user.id).save(on: req.db)
                }
                return transaction
            } else {
                throw Abort(.notFound)
            }
        } catch {
            throw Abort(.badRequest, reason: String(reflecting: error))
        }
    }
}

struct AddTagsToTransaction: Content {
    var id: String
    var tagIDs: [UUID]
}
