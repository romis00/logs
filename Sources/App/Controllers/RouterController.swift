//
//  RouterController.swift
//  App
//
//  Created by Halimjon Juraev on 3/28/18.
//

import Vapor
import Nats
import NatsUtilities

class RouterController: NatsRouter {
    let container: Container
    let gray: GraylogController
    
    init(c: Container, gray: GraylogController) {
        self.container = c
        self.gray = gray
    }
    
    func onOpen(handler: NatsProtocol) {
        print("OPEN")
        handler.subscribe("internal.report.error", queueGroup: CONSTANTS.INSTANCE_NAME) { msg in
            do {
                let notify = try JSONDecoder().decode(NatsNotificationModel<ErrorReportingNotification.Params>.self, from: msg.payload)
                let grayModel = GraylogModel.generate(notify)
                let data = try JSONEncoder().encode(grayModel)
                self.gray.write(data: data)
            } catch {
                debugPrint(error)
            }
            }.whenSuccess { (Void) in
                print("[ NATS ] [\(Date())] Subscribed to: internal.broadcast.errors")
        }
    }
    
    func onStreamingOpen(handler: NatsProtocol) {
        
    }
    func onClose(handler: NatsProtocol) {
        
    }
    func onError(handler: NatsProtocol, error: Error) {
        
    }

}

