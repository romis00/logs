import Vapor
import Nats

func boot(_ app: Application) throws {
    try LoggingSystem.bootstrap(from: &app.environment)
    
    
    let config = NatsConfig(servers: [.init(hostname: "10.7.7.137")], serverNumberOfThreads: .single, disBehavior: .reconnect, clusterName: nil)
    let natsServer = try NatsServer(natsConfig: config)

    natsServer.start(app: app)
    
    app.userInfo.updateValue(natsServer, forKey: "NatsServer")
    
    
    try app.boot()
}
