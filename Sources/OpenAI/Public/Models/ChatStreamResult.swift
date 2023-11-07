//
//  ChatStreamResult.swift
//  
//
//  Created by Sergii Kryvoblotskyi on 15/05/2023.
//

import Foundation

public struct ChatStreamResult: Codable, Equatable {
    public let id: String
    public let object: String
    public let created: TimeInterval
    public let model: Model
    public let choices: [Choice]
    public let systemFingerprint: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case object
        case created
        case model
        case choices
        case systemFingerprint = "system_fingerprint"
    }
    
    public struct Choice: Codable, Equatable {
        public let index: Int
        public let delta: Delta
        public let finishReason: String?
        
        enum CodingKeys: String, CodingKey {
            case index
            case delta
            case finishReason = "finish_reason"
        }
        
        public struct Delta: Codable, Equatable {
            public let content: String?
            public let role: Chat.Role?
            public let toolCalls: [Chat.ToolCall]?

            enum CodingKeys: String, CodingKey {
                case role
                case content
                case toolCalls = "tool_calls"
            }
        }
    }
    
    init(id: String, object: String, created: TimeInterval, model: Model, choices: [Choice], systemFingerprint: String) {
        self.id = id
        self.object = object
        self.created = created
        self.model = model
        self.choices = choices
        self.systemFingerprint = systemFingerprint
    }
}
