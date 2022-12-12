import Vapor
import MongoSwift
import SwiftJWT

func routes(_ app: Application) throws {
    let collection = app.mongoClient.db("fridge").collection("foods", withType: Food.self)
    
    // TODO - Add HTTP
    app.get { req async in
        "Hello 👋"
    }
    
    // Generate valid JWT
    app.get("generate-token") { req async -> String in
        do {
            let requestData = try req.content.decode(TokenRequest.self)
            
            let claims = TokenClaims(issuer: "Server", subject: requestData.name, expiration: Date(timeIntervalSinceNow: 3600))
            
            let token = signedToken(claims: claims)
            
            if (token == "") {
                return ""
            } else {
                return token
            }
        } catch {
            return ""
        }
    }

    // Return all items in the fridge
    app.get("fridge") { req async -> [Food] in
        if (req.headers.bearerAuthorization == nil) {
            print("No bearer token provided.")
            return []
        }
        
        if (!verifyJWT(token: req.headers.bearerAuthorization!.token)) {
            print("Provided token is not authentic.")
            return []
        }
        
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
    
    app.patch("fridge") { req async -> HTTPStatus in
        do {
            let query = try req.query.decode(DeleteQuery.self)
            let bsonId = try BSONObjectID(query.id!)
            
            do {
                let update = try req.content.decode(FoodUpdate.self)
                let updateDocument: BSONDocument = ["$set": .document(try BSONEncoder().encode(update))]
                
                try await collection.updateOne(filter: ["_id": BSON.objectID(bsonId)], update: updateDocument)
                return HTTPStatus(statusCode: 200)
            } catch {
                print(error)
                return HTTPStatus(statusCode: 500)
            }
        } catch {
            return HTTPStatus(statusCode: 400)
        }
    }
    
    // Delete item from the fridge
    app.delete("fridge") { req async -> HTTPStatus in
        do {
            let query = try req.query.decode(DeleteQuery.self)
            let bsonId = try BSONObjectID(query.id!)
            
            do {
                try await collection.deleteOne(["_id": BSON.objectID(bsonId)])
                return HTTPStatus(statusCode: 200)
            } catch {
                return HTTPStatus(statusCode: 500)
            }
        } catch {
            return HTTPStatus(statusCode: 400)
        }
    }
}
