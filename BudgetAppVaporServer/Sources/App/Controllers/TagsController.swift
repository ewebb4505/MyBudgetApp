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
        tokenProtected2.get("transactions", use: getTagTransactions)
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
        let n: Int? = Int(req.query["n"] ?? "")
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let fromParam: String = req.query["fromDate"] ?? ""
        let toParam: String = req.query["toDate"] ?? ""
        let from = formatter.date(from: fromParam)
        req.logger.debug("FROM_DATE: \(String(describing: from)) from \(fromParam)")
        let to = formatter.date(from: toParam)
        req.logger.debug("TO_DATE: \(String(describing: to)) to \(toParam)")
        
        let transactions = try await TransactionTagPivot.query(on: req.db)
            .filter(\.$user.$id == userID)
            .filter(\.$tag.$id == id)
            .with(\.$transaction)
            .all()
        
        if let to, let from {
            let filteredTransactions: [Transaction] = transactions.compactMap { $0.$transaction.value }
                .filter { $0.date <= to && $0.date >= from }
            
            return filteredTransactions
            
        } else if let n {
            let filteredTransactions: [Transaction] = Array(transactions.compactMap { $0.$transaction.value }
                .sorted(by: { $0.date > $1.date })
                .prefix(n))
            
            return filteredTransactions
            
        } else {
            return transactions.compactMap { $0.$transaction.value }
        }
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
