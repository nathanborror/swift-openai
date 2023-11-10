import Foundation

public struct ListResult<T: Codable>: Codable {
    public var object: String
    public var data: [T]
    public var firstID: String
    public var lastID: String
    public var hasMore: Bool
    
    enum CodingKeys: String, CodingKey {
        case object
        case data
        case firstID = "first_id"
        case lastID = "last_id"
        case hasMore = "has_more"
    }
}
