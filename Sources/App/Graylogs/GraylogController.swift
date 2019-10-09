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

    
    let container: Container
    weak var channel: Channel?
    let logger: Logger
    
    public init(c: Container, logger: Logger = Logger(label: "Nats.Client.logger")) throws {
        self.logger = logger
        self.container = c
        makeConnection()
    }
    
    func makeConnection() {
        let handler = GraylogHandler(container: container)
        let bootstrap = ClientBootstrap(group: container.eventLoop)
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
                    on: self.container.eventLoop.next()
                )
        }
        _ = bootstrap.connect(host: "10.7.8.132", port: 12201).map { (channel) in
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
