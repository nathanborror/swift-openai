import Foundation

public struct CompletionsResult: Codable, Equatable {
    public let id: String
    public let object: String
    public let created: TimeInterval
    public let model: String
    public let choices: [Choice]
    public let usage: Usage?
    
    public struct Choice: Codable, Equatable {
        public let text: String
        public let index: Int
        public let finishReason: String?
        
        enum CodingKeys: String, CodingKey {
            case text
            case index
            case finishReason = "finish_reason"
        }
    }
}
