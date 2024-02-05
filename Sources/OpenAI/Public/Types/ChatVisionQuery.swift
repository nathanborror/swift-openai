/// https://platform.openai.com/docs/guides/vision

import Foundation

public struct ChatVision: Codable, Equatable {
    public let role: Chat.Role
    public let content: [Content]?
    
    public struct Content: Codable, Equatable {
        public let type: String
        public let text: String?
        public let imageURL: ImageURL?
        
        public struct ImageURL: Codable, Equatable {
            public let url: String
            public let detail: String?
        }
        
        enum CodingKeys: String, CodingKey {
            case type
            case text
            case imageURL = "image_url"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case role
        case content
    }
    
    public init(role: Chat.Role, content: [Content]? = nil) {
        self.role = role
        self.content = content
    }
}

public enum ChatVisionMessage: Codable, Equatable {
    case vision(ChatVision)
    case text(Chat)
    
    private enum CodingKeys: String, CodingKey {
        case role
        case content
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let role = try container.decode(Chat.Role.self, forKey: .role)
        if let content = try? container.decode([ChatVision.Content].self, forKey: .content) {
            let chat = ChatVision(role: role, content: content)
            self = .vision(chat)
        } else if let content = try? container.decode(String.self, forKey: .content) {
            let chat = Chat(role: role, content: content)
            self = .text(chat)
        } else {
            throw DecodingError.dataCorruptedError(forKey: .content, in: container, debugDescription: "Unexpected content type")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .vision(let chat):
            try container.encode(chat.role, forKey: .role)
            try container.encode(chat.content, forKey: .content)
        case .text(let chat):
            try container.encode(chat.role, forKey: .role)
            try container.encode(chat.content, forKey: .content)
        }
    }
}

public struct ChatVisionQuery: Equatable, Codable, Streamable {
    public let model: String
    public let messages: [ChatVisionMessage]
    public let temperature: Double?
    public let topP: Double?
    public let n: Int?
    public let seed: Int?
    public let stop: [String]?
    public let maxTokens: Int?
    public let presencePenalty: Double?
    public let frequencyPenalty: Double?
    public let logitBias: [String:Int]?
    public let user: String?
    
    var stream: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case model
        case messages
        case temperature
        case topP = "top_p"
        case n
        case stream
        case seed
        case stop
        case maxTokens = "max_tokens"
        case presencePenalty = "presence_penalty"
        case frequencyPenalty = "frequency_penalty"
        case logitBias = "logit_bias"
        case user
    }
    
    public init(model: String, messages: [ChatVisionMessage], temperature: Double? = nil, topP: Double? = nil, n: Int? = nil,
                seed: Int? = nil, stop: [String]? = nil, maxTokens: Int? = nil, presencePenalty: Double? = nil,
                frequencyPenalty: Double? = nil, logitBias: [String : Int]? = nil, user: String? = nil, stream: Bool = false) {
        self.model = model
        self.messages = messages
        self.temperature = temperature
        self.topP = topP
        self.n = n
        self.seed = seed
        self.stop = stop
        self.maxTokens = maxTokens
        self.presencePenalty = presencePenalty
        self.frequencyPenalty = frequencyPenalty
        self.logitBias = logitBias
        self.user = user
        self.stream = stream
    }
}
