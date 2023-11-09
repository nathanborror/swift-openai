//
//  File.swift
//  
//
//  Created by Nathan Borror on 11/9/23.
//

import Foundation

public struct AudioSpeechQuery: Codable, Equatable {
    /// One of the available TTS models: tts-1 or tts-1-hd
    public let model: Model
    /// The text to generate audio for. The maximum length is 4096 characters.
    public let input: String
    public let voice: Voice
    public let responseFormat: ResponseFormat?
    /// The speed of the generated audio. Select a value from 0.25 to 4.0. 1.0 is the default.
    public let speed: Int?
    
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
    
    public init(model: Model, input: String, voice: Voice, responseFormat: ResponseFormat?, speed: Int?) {
        self.model = model
        self.input = input
        self.voice = voice
        self.responseFormat = responseFormat
        self.speed = speed
    }
}
