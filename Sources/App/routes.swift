import Vapor
import MongoSwift

func routes(_ app: Application) throws {
    let collection = app.mongoClient.db("fridge").collection("foods", withType: Food.self)
    
    // TODO - Add HTTP
    app.get { req async in
        "Hello 👋"
    }

    // Return all items in the fridge
    app.get("fridge") { req async -> [Food] in
        do {
            let results = try await collection.find().toArray()
            return results
        } catch {
            print("Error collecting items from MongoDB collection.")
            return []
        }
    }
    
    // Add new food item to the fridge
    app.post("fridge") { req async -> HTTPStatus in
        do {
            let food = try req.content.decode(Food.self)
            
            do {
                try await collection.insertOne(food)
                return HTTPStatus(statusCode: 201)
            } catch {
                return HTTPStatus(statusCode: 500)
            }
        } catch {
            return HTTPStatus(statusCode: 400)
        }
    }
}
