import Foundation

public struct Usage: Codable, Equatable {
    public let completion_tokens: Int?
    public let prompt_tokens: Int?
    public let total_tokens: Int?

    public let completion_tokens_details: CompletionTokensDetails?
    public let prompt_tokens_details: PromptTokensDetails?

    public struct CompletionTokensDetails: Codable, Equatable {
        public let accepted_prediction_tokens: Int
        public let audio_tokens: Int
        public let reasoning_tokens: Int
        public let rejected_prediction_tokens: Int
    }

    public struct PromptTokensDetails: Codable, Equatable {
        public let audio_tokens: Int
        public let cached_tokens: Int
    }
}
