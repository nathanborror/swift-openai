import Foundation

public struct EmbeddingsResult: Codable, Equatable {
    public let data: [Embedding]
    public let model: String
    public let usage: Usage
    
    public struct Embedding: Codable, Equatable {
        public let object: String
        public let embedding: [Double]
        public let index: Int
    }
}
