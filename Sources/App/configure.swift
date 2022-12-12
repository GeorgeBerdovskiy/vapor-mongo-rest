import Vapor
import MongoSwift

extension Application {
    // Global MongoDB client that will be used throughout the application
    public var mongoClient: MongoClient {
        get {
            self.storage[MongoClientKey.self]!
        }
        
        set {
            self.storage[MongoClientKey.self] = newValue
        }
    }

    private struct MongoClientKey: StorageKey {
        typealias Value = MongoClient
    }
}

// Configures your application
public func configure(_ app: Application) throws {
    // Serve files from /Public folder
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // Initialize client using the application's 'EventLoopGroup'
    let client = try MongoClient(Environment.get("MONGO_URI") ?? "mongodb://localhost:27017", using: app.eventLoopGroup)
    app.mongoClient = client
    
    // Register routes
    try routes(app)
}
