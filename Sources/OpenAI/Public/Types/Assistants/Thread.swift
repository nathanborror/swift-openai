import Foundation

public struct Thread: Codable {
    public var id: String
    public var object: String
    public var createdAt: Int
    public var metadata: [String: String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case object
        case createdAt = "created_at"
        case metadata
    }
}

public struct ThreadCreateQuery: Codable {
    public var messages: [Message]
    
    public struct Message: Codable {
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
}
