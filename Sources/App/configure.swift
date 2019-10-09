
import Vapor
import Nats
import NatsUtilities

/// Called before your application initializes.
func configure(_ s: inout Services) throws {
    /// Register providers first

    /// Register routes
    s.extend(Routes.self) { r, c in
        try routes(r, c)
    }

    /// Register middleware
    s.register(MiddlewareConfiguration.self) { c in
        // Create _empty_ middleware config
        var middlewares = MiddlewareConfiguration()
        
        // Serves files from `Public/` directory
        /// middlewares.use(FileMiddleware.self)
        
        // Catches errors and converts to HTTP response
        try middlewares.use(c.make(ErrorMiddleware.self))
        
        return middlewares
    }
    
    s.register(CompletionHandlers.self) { _ -> (CompletionHandlers) in
        return CompletionHandlers(constantsName: CONSTANTS.INSTANCE_NAME, constantsID: CONSTANTS.INSTANCE_ID)
    }
    s.register(GraylogController.self) { c in
        try GraylogController(c: c)
    }
    s.register(NatsRouter.self) { c in
        RouterController(c: c, gray: try c.make())
    }
    
    s.register(NatsServer.self) { container in
        let config = NatsConfig(servers: [.init(hostname: "10.7.7.137")], serverNumberOfThreads: .single, disBehavior: .reconnect, clusterName: nil)
        return try NatsServer(natsConfig: config)
        
    }
}
