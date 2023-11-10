import Foundation

public struct EditsResult: Codable, Equatable {
    public let object: String
    public let created: TimeInterval
    public let choices: [Choice]
    public let usage: Usage
    
    public struct Choice: Codable, Equatable {
        public let text: String
        public let index: Int
    }
}
