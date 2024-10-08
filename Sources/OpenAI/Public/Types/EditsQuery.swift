import Foundation

public struct EditsQuery: Codable {
    /// ID of the model to use.
    public let model: String
    /// Input text to get embeddings for.
    public let input: String?
    /// The instruction that tells the model how to edit the prompt.
    public let instruction: String
    /// The number of images to generate. Must be between 1 and 10.
    public let n: Int?
    /// What sampling temperature to use. Higher values means the model will take more risks. Try 0.9 for more creative applications, and 0 (argmax sampling) for ones with a well-defined answer.
    public let temperature: Float?
    /// An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of the tokens with top_p probability mass. So 0.1 means only the tokens comprising the top 10% probability mass are considered.
    public let topP: Float?
    
    public init(model: String, input: String?, instruction: String, n: Int? = nil, temperature: Float? = nil, topP: Float? = nil) {
        self.model = model
        self.input = input
        self.instruction = instruction
        self.n = n
        self.temperature = temperature
        self.topP = topP
    }
}
