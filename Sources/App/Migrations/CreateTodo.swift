import Foundation
import NatsUtilities


struct GraylogModel: Codable {
    let version: String = "1.1"
    let host: String
    let shortMessage: String
    let fullMessage: String
    let timestamp: Double?
    let level: Int
    
    
    let id: Int
    let suggestedFixes: [String]?
    let possibleCauses: [String]?
    let sourceLocation: SourceLocation?
    let stackTrace: [String]?
    let originalMessage: String?
    let natsSubject: String?
    let moduleName: String?
    let moduleID: UUID?
    

    enum CodingKeys: String, CodingKey {
        case version
        case host
        case shortMessage = "short_message"
        case fullMessage = "full_message"
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
    
    
    
    static func generate(_ notification: NatsNotificationModel<ErrorReportingNotification.Params>) -> GraylogModel{
        return GraylogModel(host: notification.params.moduleName ?? "", shortMessage: notification.params.error.description, fullMessage: notification.params.error.fullDescription, timestamp: Date().timeIntervalSince1970, level: 5, id: notification.params.error.error.id, suggestedFixes: notification.params.error.suggestedFixes, possibleCauses: notification.params.error.possibleCauses, sourceLocation: notification.params.error.sourceLocation, stackTrace: notification.params.error.stackTrace, originalMessage: notification.params.originalMessage, natsSubject: notification.params.natsSubject, moduleName: notification.params.moduleName, moduleID: notification.params.moduleID)
    }
    
}
