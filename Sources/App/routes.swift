import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "Hello 👋"
    }

    // Return all items in the fridge
    app.get("fridge") { req async -> String in
        // TODO - Replace with MongoDB query
        "This route returns all the food inside the fridge 🍔"
    }
}
