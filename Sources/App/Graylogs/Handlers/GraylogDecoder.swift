//
//  File.swift
//  
//
//  Created by Halimjon Juraev on 9/23/19.
//

import Foundation
import NIO
import Logging

class GraylogDecoder: ByteToMessageDecoder {
    func decode(context: ChannelHandlerContext, buffer: inout ByteBuffer) throws -> DecodingState {
        print(buffer.readString(length: buffer.readableBytes))
            
        return .continue
    }
    
    func decodeLast(context: ChannelHandlerContext, buffer: inout ByteBuffer, seenEOF: Bool) throws -> DecodingState {
        print(buffer.readString(length: buffer.readableBytes))

        return .continue
    }
    
    typealias InboundOut = Data
    
}
