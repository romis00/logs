//
//  File.swift
//  
//
//  Created by Halimjon Juraev on 9/23/19.
//

import Foundation
import Vapor
import NIO
import Logging





public final class GraylogController {

    let app: Application
    //let eventLoop = EventLoop
    weak var channel: Channel?
    let logger: Logger
    
    init(app: Application, logger: Logger = Logger(label: "Nats.Client.logger")) throws {
        self.app = app
        self.logger = logger
        makeConnection()
    }
    
    func makeConnection() {
        let handler = GraylogHandler()
        let bootstrap = ClientBootstrap(group: app.eventLoopGroup.next())
            .channelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
            .channelInitializer { channel in
                self.channel = channel
                let handlers: [(ChannelHandler, String)] = [
                    (MessageToByteHandler(GraylogEncoder()), "Nats.Outgoing"),
                    (ByteToMessageHandler(GraylogDecoder()), "Nats.Incoming"),
                    (handler, "Nats.Queue")
                ]
                return .andAllSucceed(
                    handlers.map { channel.pipeline.addHandler($0, name: $1) },
                    on: self.app.eventLoopGroup.next()
                )
        }
        _ = bootstrap.connect(host: "0.0.0.0", port: 4222).map { (channel) in //host: "10.7.8.132", port: 12201
            _ = channel.closeFuture.map { _ in
                fatalError("CONNECTION TO GRAYLOGS DISCONNECTED")
            }
        }.recover { error in
            debugPrint(error)
        }
    }
    
    func write(data: Data) {
        channel?.write(data)
        channel?.flush()
    }

    

    deinit {
        logger.info("DEINITILIZING GRAYLOG CONTROLLER")
    }
}
