import Foundation

public struct AudioSpeechQuery: Codable, Equatable {
    public let model: String
    public let input: String
    public let voice: Voice
    public let responseFormat: ResponseFormat?
    public let speed: Float?
    
    public enum ResponseFormat: String, Codable {
        case mp3, opus, aac, flac
    }
    
    public enum Voice: String, Codable {
        case alloy, echo, fable, onyx, nova, shimmer
    }
    
    enum CodingKeys: String, CodingKey {
        case model
        case input
        case voice
        case responseFormat = "response_format"
        case speed
    }
    
    public init(model: String, input: String, voice: Voice, responseFormat: ResponseFormat? = nil, speed: Float? = nil) {
        self.model = model
        self.input = input
        self.voice = voice
        self.responseFormat = responseFormat
        self.speed = speed
    }
}
