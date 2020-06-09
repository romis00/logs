//
//  File.swift
//  
//
//  Created by Halimjon Juraev on 9/23/19.
//

import NIO
import Vapor

public final class GraylogHandler: ChannelInboundHandler {
    
    /// See `ChannelInboundHandler.InboundIn`
    public typealias InboundIn = Data
    
    /// See `ChannelInboundHandler.OutboundOut`
    public typealias OutboundOut = Data

    
    //public let container: Container
    public let logger: Logger
    

    
    private var context: ChannelHandlerContext?

    init(logger: Logger = Logger(label: "Nats.Client")) {
        self.logger = logger        
    }

    public func write(context: ChannelHandlerContext, data: NIOAny, promise: EventLoopPromise<Void>?) {
        context.write(data, promise: promise)
    }
    
    public func handlerAdded(context: ChannelHandlerContext) {
        self.context = context
    }

}
