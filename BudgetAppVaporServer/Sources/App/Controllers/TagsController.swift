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
    }
    
    func getTags(req: Request) async throws -> [Tag] {
        try await Tag.query(on: req.db).all()
    }
    
    func getTag(req: Request) async throws -> Tag {
        let id = UUID(uuidString: (req.query["id"] ?? "").replacingOccurrences(of: "\"", with: ""))
        req.logger.info("Requested ID: \(String(describing: id?.uuidString))")
        guard let tag = try await Tag.find(id, on: req.db) else {
            throw Abort(.notFound)
        }
        return tag
    }
    
    func createTag(req: Request) async throws -> Tag {
        let tag = try req.content.decode(Tag.self)
        try await tag.save(on: req.db)
        return tag
    }
    
    func deleteTag(req: Request) async throws -> HTTPStatus {
        let id = UUID(uuidString: (req.query["id"] ?? "").replacingOccurrences(of: "\"", with: ""))
        req.logger.info("Requested ID: \(String(describing: id?.uuidString))")
        guard let requestedTag = try await Tag.find(id, on: req.db),
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
