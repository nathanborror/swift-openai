import Foundation

public struct ChatResult: Codable, Equatable {
    public let id: String
    public let object: String
    public let created: TimeInterval
    public let model: String
    public let choices: [Choice]
    public let usage: Usage?
    public let systemFingerprint: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case object
        case created
        case model
        case choices
        case usage
        case systemFingerprint = "system_fingerprint"
    }
    
    public struct Choice: Codable, Equatable {
        public let index: Int
        public let message: Chat
        public let finishReason: String?
        
        enum CodingKeys: String, CodingKey {
            case index
            case message
            case finishReason = "finish_reason"
        }
    }
    
    init(id: String, object: String, created: TimeInterval, model: String, choices: [Choice], usage: Usage, systemFingerprint: String?) {
        self.id = id
        self.object = object
        self.created = created
        self.model = model
        self.choices = choices
        self.usage = usage
        self.systemFingerprint = systemFingerprint
    }
}
