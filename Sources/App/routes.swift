import Vapor

func routes(_ r: Routes, _ c: Container) throws {
    r.get { req -> String in
        return "It works!"
    }

    r.get("hello") { req -> String in
        return "Hello, world!"
    }

}
