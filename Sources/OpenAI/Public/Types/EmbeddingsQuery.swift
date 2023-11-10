import Foundation

public struct EmbeddingsQuery: Codable {
    /// ID of the model to use.
    public let model: String
    /// Input text to get embeddings for.
    public let input: String

    public init(model: String, input: String) {
        self.model = model
        self.input = input
    }
}
