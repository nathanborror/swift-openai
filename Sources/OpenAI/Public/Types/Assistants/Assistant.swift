import Foundation

public struct Assistant: Codable {
    public var id: String
    public var object: String
    public var createdAt: Int
    public var name: String?
    public var description: String?
    public var model: String
    public var instructions: String?
    public var tools: [ChatQuery.Tool]
    public var fileIDs: [String]
    public var metadata: [String: String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case object
        case createdAt = "created_at"
        case name
        case description
        case model
        case instructions
        case tools
        case fileIDs = "file_ids"
        case metadata
    }
    
    public struct File: Codable {
        public var id: String
        public var object: String
        public var createdAt: Int
        public var assistantID: String
        
        enum CodingKeys: String, CodingKey {
            case id
            case object
            case createdAt = "created_at"
            case assistantID = "assistant_id"
        }
    }
}

public struct AssistantCreateQuery: Codable {
    public var model: String
    public var name: String?
    public var description: String?
    public var instructions: String?
    public var tools: [ChatQuery.Tool]?
    public var fileIDs: [String]?
    public var metadata: [String: String]?
    
    enum CodingKeys: String, CodingKey {
        case model
        case name
        case description
        case instructions
        case tools
        case fileIDs = "file_ids"
        case metadata
    }
}
