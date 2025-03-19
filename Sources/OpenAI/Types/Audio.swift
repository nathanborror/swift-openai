import Foundation

public struct SpeechRequest: Codable, Sendable {
    public var model: String
    public var input: String
    public var voice: Voice
    public var response_format: ResponseFormat?
    public var speed: Double?

    public enum Voice: String, CaseIterable, Codable, Sendable {
        case alloy, echo, fable, onyx, nova, shimmer
    }

    public enum ResponseFormat: String, CaseIterable, Codable, Sendable {
        case mp3, opus, aac, flac, wav, pcm
    }

    public init(model: String, input: String, voice: Voice, response_format: ResponseFormat? = nil, speed: Double? = nil) {
        self.model = model
        self.input = input
        self.voice = voice
        self.response_format = response_format
        self.speed = speed
    }
}

public struct TranscriptionRequest: Codable, Sendable {
    public var file: URL
    public var model: String
    public var language: String?
    public var prompt: String?
    public var response_format: ResponseFormat?
    public var temperature: Double?
    //public var timestamp_granularities[]: ?

    public enum ResponseFormat: String, CaseIterable, Codable, Sendable {
        case json, text, srt, verbose_json, vtt
    }

    public init(file: URL, model: String, language: String? = nil, prompt: String? = nil,
                response_format: ResponseFormat? = nil, temperature: Double? = nil) {
        self.file = file
        self.model = model
        self.language = language
        self.prompt = prompt
        self.response_format = response_format
        self.temperature = temperature
    }
}

public struct TranscriptionResponse: Codable, Sendable {
    public let text: String
    public let language: String?
    public let duration: String?
    public let words: [Word]?
    public let segments: [Segment]?

    public struct Word: Codable, Sendable {
        public let word: String
        public let start: Double
        public let end: Double
    }

    public struct Segment: Codable, Sendable {
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

public struct TranslationRequest: Codable, Sendable {
    public var file: Data
    public var model: String
    public var prompt: String?
    public var response_format: ResponseFormat?
    public var temperature: Double?

    public enum ResponseFormat: String, CaseIterable, Codable, Sendable {
        case json, text, srt, verbose_json, vtt
    }

    public init(file: Data, model: String, prompt: String? = nil, response_format: ResponseFormat? = nil,
                temperature: Double? = nil) {
        self.file = file
        self.model = model
        self.prompt = prompt
        self.response_format = response_format
        self.temperature = temperature
    }
}

public struct TranslationResponse: Codable, Sendable {
    public let text: String
}
