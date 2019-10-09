//
//  File.swift
//  
//
//  Created by Halimjon Juraev on 9/23/19.
//

import Foundation
import NIO
import struct Logging.Logger


class GraylogEncoder: MessageToByteEncoder{
    
    typealias OutboundIn = Data
    
    private let logger: Logger
    
    public init(logger: Logger = Logger(label: "Nats.MessageEncoder")) {
        self.logger = logger
    }

    public func encode(data: Data, out: inout ByteBuffer) throws {
        out.writeBytes(data)
        out.writeInteger(0, as: UInt8.self)
        
        
        
//        try out.writeString("{ \"version\": \"1.1\", \"host\": \"motherfucker.org\", \"short_message\": \"A short message\", \"level\": 5, \"_some_info\": \"foo\" }", encoding: .utf8)
//        out.writeInteger(0, as: UInt8.self)
        
        logger.debug("Encoded \(data) to \(getPrintableString(for: &out))")
    }
    
    private func getPrintableString(for buffer: inout ByteBuffer) -> String {
        return String(describing: buffer.getString(at: 0, length: buffer.readableBytes))
            .dropFirst(9)
            .dropLast()
            .description
    }
}


extension String {
    var nullTerminated: Data? {
        if var data = self.data(using: String.Encoding.utf8) {
            data.append(0)
            return data
        }
        return nil
    }
}
