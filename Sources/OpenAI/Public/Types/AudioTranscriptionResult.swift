import Foundation

public struct AudioTranscriptionResult: Codable, Equatable {
    public let text: String
    public let language: String?
    public let duration: String?
    public let words: [Word]?
    public let segments: [Segment]?

    public struct Word: Codable, Equatable {
        public let word: String
        public let start: Double
        public let end: Double
    }

    public struct Segment: Codable, Equatable {
        public let id: Int
        public let seek: Int
        public let start: Double
        public let end: Double
        public let text: String
        public let tokens: [Int]
        public let temperature: Double
        public let avg_logprob: Double
        public let compression_ratio: Double
        public let no_speech_prob: Double
    }
}
