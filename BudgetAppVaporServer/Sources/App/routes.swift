import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    
    app.get("transactions") { req async throws in
        try await Transaction.query(on: req.db).all()
    }
    
    app.post("transaction") { req -> EventLoopFuture<Transaction> in
      let transaction = try req.content.decode(Transaction.self)
      return transaction.save(on: req.db).map {
          transaction
      }
    }
    
    app.delete("transaction") { req throws -> EventLoopFuture<HTTPStatus> in
        let id = UUID(uuidString: (req.query["transactionID"] ?? "").replacingOccurrences(of: "\"", with: ""))
        req.logger.info("Requested ID: \(id?.uuidString)")
        return Transaction.find(id, on: req.db)
            .unwrap(or: Abort(.notFound, reason: "Could not find transaction ID"))
            .flatMap { transaction in
                transaction.delete(on: req.db)
                    .transform(to: .noContent)
            }
    }
}
