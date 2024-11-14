/// https://platform.openai.com/docs/api-reference/chat

import Foundation
import SharedKit

public struct Chat: Codable, Equatable {
    public let role: Role
    public let content: [Content]?
    public let name: String?
    public let toolCalls: [ToolCall]?
    public let toolCallID: String?

    public enum Role: String, Codable, Equatable {
        case system
        case assistant
        case user
        case tool
    }

    public struct Content: Codable, Equatable {
        /// The type of the content part: `text`, `image_url`, or `input_audio`.
        public let type: String
        public let text: String?
        public let imageURL: ImageURL?
        public let inputAudio: InputAudio?

        public struct ImageURL: Codable, Equatable {
            /// Either a URL of the image or the base64 encoded image data.
            public let url: String
            /// Specifies the detail level of the image: `low` or `high`.
            /// https://platform.openai.com/docs/guides/vision#low-or-high-fidelity-image-understanding
            public let detail: String?

            public init(url: String, detail: String? = nil) {
                self.url = url
                self.detail = detail
            }
        }

        public struct InputAudio: Codable, Equatable {
            /// Base64 encoded audio data.
            public let data: String
            /// The format of the encoded audio data. Currently supports `wav` and `mp3`.
            public let format: String

            public init(data: String, format: String) {
                self.data = data
                self.format = format
            }
        }

        enum CodingKeys: String, CodingKey {
            case type
            case text
            case imageURL = "image_url"
            case inputAudio = "input_audio"
        }

        public init(type: String, text: String? = nil, imageURL: ImageURL? = nil, inputAudio: InputAudio? = nil) {
            self.type = type
            self.text = text
            self.imageURL = imageURL
            self.inputAudio = inputAudio
        }
    }

    public struct ToolCall: Codable, Equatable {
        public let id: String?
        public let type: String?
        public let function: Function

        public struct Function: Codable, Equatable {
            public let name: String?
            public let arguments: String?

            public init(name: String?, arguments: String?) {
                self.name = name
                self.arguments = arguments
            }
        }

        public init(id: String?, type: String?, function: Function) {
            self.id = id
            self.type = type
            self.function = function
        }
    }

    enum CodingKeys: String, CodingKey {
        case role
        case content
        case name
        case toolCalls = "tool_calls"
        case toolCallID = "tool_call_id"
    }

    public init(role: Role, content: [Content]? = nil, name: String? = nil, toolCalls: [ToolCall]? = nil, toolCallID: String? = nil) {
        self.role = role
        self.content = content
        self.name = name
        self.toolCalls = toolCalls
        self.toolCallID = toolCallID
    }

    public init(role: Role, content: String? = nil, name: String? = nil, toolCalls: [ToolCall]? = nil, toolCallID: String? = nil) {
        self.role = role
        self.content = (content != nil) ? [.init(type: "text", text: content!)] : nil
        self.name = name
        self.toolCalls = toolCalls
        self.toolCallID = toolCallID
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.role = try container.decode(Role.self, forKey: .role)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.toolCalls = try container.decodeIfPresent([ToolCall].self, forKey: .toolCalls)
        self.toolCallID = try container.decodeIfPresent(String.self, forKey: .toolCallID)

        if let contentArray = try? container.decode([Content].self, forKey: .content) {
            self.content = contentArray
        } else if let contentString = try? container.decode(String.self, forKey: .content) {
            self.content = [Content(type: "text", text: contentString)]
        } else {
            self.content = nil
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(role, forKey: .role)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(toolCalls, forKey: .toolCalls)
        try container.encodeIfPresent(toolCallID, forKey: .toolCallID)

        if let content = content {
            try container.encode(content, forKey: .content)
        }
    }
}

public struct ChatQuery: Equatable, Codable, Streamable {
    public let model: String
    public let messages: [Chat]
    public let tools: [Tool]?
    public let toolChoice: ToolChoice?
    public let temperature: Float?
    public let topP: Float?
    public let n: Int?
    public let responseFormat: ResponseFormat?
    public let seed: Int?
    public let stop: [String]?
    public let maxTokens: Int?
    public let presencePenalty: Float?
    public let frequencyPenalty: Float?
    public let logitBias: [String:Int]?
    public let user: String?
    
    var stream: Bool = false

    public enum ResponseFormat: String, Codable {
        case text
        case json = "json_object"
    }
    
    public struct Tool: Codable, Equatable {
        public let type: String
        public let function: Function?
        
        public struct Function: Codable, Equatable {
            public let name: String
            public let description: String?
            public let parameters: JSONSchema?
          
            public init(name: String, description: String? = nil, parameters: JSONSchema? = nil) {
              self.name = name
              self.description = description
              self.parameters = parameters
            }
        }
        
        public init(type: String, function: Function) {
            self.type = type
            self.function = function
        }
    }
    
    public enum ToolChoice: Codable, Equatable {
        case none
        case auto
        case tool(Tool)
        
        public struct Tool: Codable, Equatable {
            public var type: String
            public var function: Function
            
            public struct Function: Codable, Equatable {
                public var name: String
                
                public init(name: String) {
                    self.name = name
                }
            }
            
            public init(type: String, function: Function) {
                self.type = type
                self.function = function
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case none
            case auto
            case tool
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .none:
                try container.encode(CodingKeys.none.rawValue)
            case .auto:
                try container.encode(CodingKeys.auto.rawValue)
            case .tool(let tool):
                try container.encode(tool)
            }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case model
        case messages
        case tools
        case toolChoice = "tool_choice"
        case temperature
        case topP = "top_p"
        case n
        case stream
        case responseFormat = "response_format"
        case seed
        case stop
        case maxTokens = "max_tokens"
        case presencePenalty = "presence_penalty"
        case frequencyPenalty = "frequency_penalty"
        case logitBias = "logit_bias"
        case user
    }
    
    public init(model: String, messages: [Chat], tools: [Tool]? = nil, toolChoice: ToolChoice? = nil, temperature: Float? = nil, topP: Float? = nil, n: Int? = nil, responseFormat: ResponseFormat? = nil, seed: Int? = nil, stop: [String]? = nil, maxTokens: Int? = nil, presencePenalty: Float? = nil, frequencyPenalty: Float? = nil, logitBias: [String : Int]? = nil, user: String? = nil, stream: Bool = false) {
        self.model = model
        self.messages = messages
        self.tools = tools
        self.toolChoice = toolChoice
        self.temperature = temperature
        self.topP = topP
        self.n = n
        self.responseFormat = responseFormat
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
