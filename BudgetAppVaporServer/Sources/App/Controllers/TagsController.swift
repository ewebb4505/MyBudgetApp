//
//  TagsController.swift
//
//
//  Created by Evan Webb on 10/4/23.
//

import Foundation
import FluentKit
import Fluent
import Vapor

struct TagsController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let tags = routes.grouped("tags")
        let tokenProtected = tags.grouped(Token.authenticator())
        tokenProtected.get(use: getTags)
        tokenProtected.post(use: createTag)
        tokenProtected.delete(use: deleteTag)
        
        let tag = routes.grouped("tag")
        let tokenProtected2 = tag.grouped(Token.authenticator())
        tokenProtected2.get(use: getTag)
        tokenProtected2.get("tag", "transactions", use: getTagTransactions)
    }
    
    func getTags(req: Request) async throws -> [Tag] {
        guard let user = try? req.auth.require(User.self).asPublic() else {
            throw Abort(.badRequest, reason: "could not find user id.")
        }
        let userID = user.id
        return try await Tag.query(on: req.db).filter(\.$user.$id == userID).all()
    }
    
    func getTag(req: Request) async throws -> Tag {
        guard let user = try? req.auth.require(User.self), let userID = user.id else {
            throw Abort(.badRequest, reason: "could not find user id.")
        }
        
        guard let id = UUID(uuidString: (req.query["id"] ?? "").replacingOccurrences(of: "\"", with: "")) else {
            throw Abort(.badRequest, reason: "could not tag id.")
        }
        
        req.logger.info("Requested ID: \(String(describing: id.uuidString))")
        guard let tag = try await Tag.query(on: req.db)
            .filter(\.$user.$id == userID)
            .filter(\.$id == id)
            .first() else {
            throw Abort(.notFound)
        }
        return tag
    }
    
    func getTagTransactions(req: Request) async throws -> [Transaction] {
        guard let user = try? req.auth.require(User.self), let userID = user.id else {
            throw Abort(.badRequest, reason: "could not find user id.")
        }
        
        guard let id = UUID(uuidString: (req.query["id"] ?? "").replacingOccurrences(of: "\"", with: "")) else {
            throw Abort(.badRequest, reason: "could not tag id.")
        }
        
        // TODO: Get transactions with tag id
        return []
    }
    
    func createTag(req: Request) async throws -> Tag {
        guard let user = try? req.auth.require(User.self), let userID = user.id else {
            throw Abort(.badRequest, reason: "could not find user id.")
        }
    
        let tagRequest = try req.content.decode(CreateTagRequest.self)
        let tag = Tag(userID: userID, title: tagRequest.title)
        try await tag.save(on: req.db)
        return tag
    }
    
    func deleteTag(req: Request) async throws -> HTTPStatus {
        guard let user = try? req.auth.require(User.self), let userID = user.id else {
            throw Abort(.badRequest, reason: "could not find user id.")
        }
        
        guard let id = UUID(uuidString: (req.query["id"] ?? "").replacingOccurrences(of: "\"", with: "")) else {
            throw Abort(.badRequest, reason: "could not tag id.")
        }
        
        req.logger.info("\n\n\nRequested ID: \(String(describing: id.uuidString))\n\n\n")
        
        guard let requestedTag = try await Tag.query(on: req.db)
            .filter(\.$user.$id == userID)
            .filter(\.$id == id)
            .first(),
              let id = requestedTag.id else {
            throw Abort(.notFound)
        }
        
        // delete this requested tag from the pivot table first
        try await TransactionTagPivot.query(on: req.db)
            .filter(\.$tag.$id == id)
            .all()
            .delete(on: req.db)
            
        try await requestedTag.delete(on: req.db)
        return .ok
    }
}

struct CreateTagRequest: Content {
    var title: String
}
