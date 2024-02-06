import NIOSSL
import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database",
        tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql)

    app.migrations.add(CreateTransaction())
    app.migrations.add(CreateTag())
    app.migrations.add(CreateTransactionTagPivot())
    app.migrations.add(UpdateTransactionTagPivot())
    app.migrations.add(CreateNewTransactionTagPivot())
    
    app.migrations.add(CreateBudget())
    app.migrations.add(CreateBudgetCategory())
    app.migrations.add(UpdateTransaction())
    app.migrations.add(CreateUsers())
    app.migrations.add(CreateTokens())
    
    //adding user keys to existing models
    app.migrations.add(UpdateTransactionV3())
    app.migrations.add(UpdateBudget())
    app.migrations.add(UpdateBudgetCategory())
    app.migrations.add(UpdateTag())
    
    app.logger.logLevel = .debug
    try await app.autoMigrate().get()

    // register routes
    try app.register(collection: TransactionsController())
    try app.register(collection: TagsController())
    try app.register(collection: TransactionTagsController())
    try app.register(collection: BudgetController())
    try app.register(collection: BudgetCategoryController())
    try app.register(collection: UserController())
}
