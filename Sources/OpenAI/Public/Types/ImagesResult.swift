import Foundation

public struct ImagesResult: Codable, Equatable {
    public let created: TimeInterval?
    public let data: [ImageResult]?
    
    public struct ImageResult: Codable, Equatable {
        public let url: String?
        public let b64JSON: String?
        public let revisedPrompt: String?
        
        enum CodingKeys: String, CodingKey {
            case url
            case b64JSON = "b64_json"
            case revisedPrompt = "revised_prompt"
        }
    }
}
