//
//  RouterController.swift
//  App
//
//  Created by Halimjon Juraev on 3/28/18.
//

import Vapor
import Nats
import NatsUtilities


extension Application {
    var router: RouterController {
        if let existing = self.storage[RouterControllerKey.self] {
            return existing
        } else {
            let somegray = try! GraylogController(app: self)
            let new = RouterController(somegray)
            self.storage[RouterControllerKey.self] = new
            return new
        }
    }

    struct RouterControllerKey: StorageKey {
        typealias Value = RouterController
    }
    
    class RouterController {
        
        let gray: GraylogController
        
        init(_ gray: GraylogController) {
            self.gray = gray
        }
        
        func onOpen(conn: NatsConnection) {
            
            print("OPEN")
            
            conn.subscribe(CONSTANTS.INTERNAL_REPORT_NAME, queueGroup: CONSTANTS.INSTANCE_NAME) { msg in
                do {
                    let notify = try JSONDecoder().decode(NatsNotificationModel<ErrorReportingNotification.Params>.self, from: msg.payload)
                    let grayModel = GraylogModel.generate(notify)
                    let data = try JSONEncoder().encode(grayModel)
                    self.gray.write(data: data)
                    
                    msg.reply(data)
                    
                } catch {
                    debugPrint(error)
                }
                }.whenSuccess { (Void) in
                    print("[ NATS ] [\(Date())] Subscribed to: internal.broadcast.errors")
            }
            
            conn.request(CONSTANTS.INTERNAL_REPORT_NAME, payload: Data(), timeout: 60)
            
        }
        
        func onStreamingOpen(conn: NatsConnection) {
            
        }
        func onClose(conn: NatsConnection) {
            
        }
        func onError(conn: NatsConnection, error: Error) {
            
            print("ON ERROR GOES")
            
        }

    }
}
