import Foundation

public struct Message: Codable {
    public var id: String
    public var object: String
    public var createdAt: Int
    public var threadID: String
    public var role: String
    public var content: [Content]
    public var assistantID: String?
    public var runID: String?
    public var fileIDs: [String]
    public var metadata: [String: String]
    
    public enum Content: Codable {
        case text(Text)
        case image(ImageFile)
    }
    
    public struct Text: Codable {
        public var value: String
        public var annotations: [String]
    }
    
    public struct ImageFile: Codable {
        public var fileID: String
        
        enum CodingKeys: String, CodingKey {
            case fileID = "file_id"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case object
        case createdAt = "created_at"
        case threadID = "thread_id"
        case role
        case content
        case assistantID = "assistant_id"
        case runID = "run_id"
        case fileIDs = "file_ids"
        case metadata
    }
}

public struct MessageCreateQuery: Codable {
    public var role: String
    public var content: String
    public var fileIDs: [String]
    public var metadata: [String: String]?
    
    enum CodingKeys: String, CodingKey {
        case role
        case content
        case fileIDs = "file_ids"
        case metadata
    }
}
