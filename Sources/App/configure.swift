import Fluent
import FluentPostgresDriver
import Vapor
import Nats
import NatsUtilities

/// Called before your application initializes.
public func configure(_ app: Application) throws {
    /// Register providers first
    
    app.http.server.configuration.port = 9192

//    app.register(GraylogController.self) { c in
//        try GraylogController(c: c)
//    }
//    app.register(NatsRouter.self) { c in
//        RouterController(c: c, gray: try c.make())
//    }
    
    app.nats.configuration = .init(host: "0.0.0.0", disBehavior: .fatalCrash, clusterName: nil, streaming: false, auth_token: "mytoken", onOpen: app.router.onOpen, onStreamingOpen: app.router.onStreamingOpen, onClose: app.router.onClose, onError: app.router.onError)
        
    app.databases.use(.postgres(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        username: Environment.get("DATABASE_USERNAME") ?? "roman",
        password: Environment.get("DATABASE_PASSWORD") ?? "",
        database: Environment.get("DATABASE_NAME") ?? "data"
    ), as: .psql)
    
    try routes(app)
}
