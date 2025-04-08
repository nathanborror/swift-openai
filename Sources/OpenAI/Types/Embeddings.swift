import Foundation

public struct EmbeddingsRequest: Codable, Equatable {
    public var input: String
    public var model: String
    public var encoding_format: String?
    public var dimensions: Int?
    public var user: String?

    public init(input: String, model: String, encoding_format: String? = nil, dimensions: Int? = nil, user: String? = nil) {
        self.input = input
        self.model = model
        self.encoding_format = encoding_format
        self.dimensions = dimensions
        self.user = user
    }
}

public struct EmbeddingsResponse: Decodable {
    public let object: String?
    public let data: [Embedding]
    public let model: String
    public let usage: Usage?

    public struct Embedding: Decodable {
        public let object: String?
        public let embedding: [Double]
        public let index: Int
    }

    public struct Usage: Decodable {
        public let prompt_tokens: Int
        public let total_tokens: Int
    }
}
