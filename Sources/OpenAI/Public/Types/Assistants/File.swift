import Foundation

public struct File: Codable {
    public var id: String
    public var object: String
    public var createdAt: Int
    public var assistantID: String?
    public var messageID: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case object
        case createdAt = "created_at"
        case assistantID = "assistant_id"
        case messageID = "message_id"
    }
}
