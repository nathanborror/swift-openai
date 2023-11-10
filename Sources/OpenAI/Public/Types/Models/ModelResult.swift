import Foundation

public struct ModelResult: Codable, Equatable, Identifiable {
    public let id: String
    public let object: String
    public let ownedBy: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case object
        case ownedBy = "owned_by"
    }
}
