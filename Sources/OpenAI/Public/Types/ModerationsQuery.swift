import Foundation

public struct ModerationsQuery: Codable {
    /// The input text to classify.
    public let input: String
    /// ID of the model to use.
    public let model: String?

    public init(input: String, model: String? = nil) {
        self.input = input
        self.model = model
    }
}
