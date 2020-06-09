import Vapor
import Fluent

func routes(_ app: Application) throws {
    app.get { req -> String in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }

}
