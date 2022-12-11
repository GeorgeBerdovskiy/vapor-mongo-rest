import Vapor
import MongoSwiftSync

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // register routes
    let mongo = try MongoClient("mongodb://localhost:27017")
    try routes(app)
}
