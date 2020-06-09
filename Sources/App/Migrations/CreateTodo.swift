import Foundation
import NatsUtilities


struct GraylogModel: Codable {
    //let shortMessage: String
    //let fullMessage: String
    let version: Int
    let host: String
    let timestamp: Date//Double?
    let level: Int
    
    let id: Int
    let suggestedFixes: String?
    let possibleCauses: String?
    let sourceLocation: ErrorSource?
    let stackTrace: String?
    let originalMessage: NatsMessageCodable?
    let natsSubject: String?
    let moduleName: String?
    let moduleID: UUID?
    
    enum CodingKeys: String, CodingKey {
        //case shortMessage = "short_message"
        //case fullMessage = "full_message"
        case version
        case host
        case timestamp
        case level
        
        case id = "_id"
        case suggestedFixes = "_suggestedFixes"
        case possibleCauses = "_possibleCauses"
        case sourceLocation = "_sourceLocation"
        case stackTrace = "_stackTrace"
        case originalMessage = "_originalMessage"
        case natsSubject = "_natsSubject"
        case moduleName = "_moduleName"
        case moduleID = "_moduleID"
    }
    
    init(from: Decoder, version: Int, host: String, timestamp: Date, level: Int, id: Int, suggestedFixes: String?, possibleCauses: String?, sourceLocation: ErrorSource?, stackTrace: String?, originalMessage: NatsMessageCodable?, natsSubject: String?, moduleName: String?, moduleID: UUID?) {
        
        self.version = version
        self.host = host
        self.timestamp = timestamp
        self.level = level
        
        self.id = id
        self.suggestedFixes = suggestedFixes
        self.possibleCauses = possibleCauses
        self.sourceLocation = sourceLocation
        self.stackTrace = stackTrace
        self.originalMessage = originalMessage
        self.natsSubject = natsSubject
        self.moduleName = moduleName
        self.moduleID = moduleID
    }
    
    static func generate(_ notification: NatsNotificationModel<ErrorReportingNotification.Params>) -> GraylogModel{
        return GraylogModel(from: Decoder.self as! Decoder, version: notification.version, host: notification.params.identifier, timestamp: Date(), level: 5, id: notification.params.id, suggestedFixes: "", possibleCauses: notification.params.reason, sourceLocation: notification.params.source, stackTrace: notification.params.stackTrace, originalMessage: notification.params.originalMessage, natsSubject: notification.params.userInfo, moduleName: notification.method, moduleID: UUID())
    }
//    1. Overloads for 'GraylogModel' exist with these partially matching parameter lists: (from: Decoder), (host: String, shortMessage: String, fullMessage: String, timestamp: Double?, level: Int, id: Int, suggestedFixes: [String]?, possibleCauses: [String]?, stackTrace: [String]?, originalMessage: String?, natsSubject: String?, moduleName: String?, moduleID: UUID?)
}
