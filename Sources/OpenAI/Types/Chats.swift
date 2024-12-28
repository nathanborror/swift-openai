import Foundation
import SharedKit

public struct ChatRequest: Codable, Equatable {
    public var messages: [Message]
    public var model: String
    public var store: Bool?
    public var reasoning_effort: ReasoningEffort?
    // public var metadata
    public var frequency_penalty: Double?
    public var logit_bias: [String: Int]?
    public var logprobs: Bool?
    public var top_logprobs: Int?
    public var max_completion_tokens: Int?
    public var n: Int?
    public var modalities: [String]?
    // public var prediction
    public var audio: Audio?
    public var presence_penalty: Double?
    public var response_format: ResponseFormat?
    public var seed: Int?
    public var service_tier: String?
    public var stop: [String]?
    public var stream: Bool?
    public var stream_options: StreamOptions?
    public var temperature: Double?
    public var top_p: Double?
    public var tools: [Tool]?
    public var tool_choice: ToolChoice?
    public var parallel_tool_calls: Bool?
    public var user: String?

    public enum ReasoningEffort: String, CaseIterable, Codable {
        case low
        case medium
        case high
    }

    public struct Audio: Codable, Equatable {
        public var voice: String
        public var format: String

        public init(voice: String, format: String) {
            self.voice = voice
            self.format = format
        }
    }

    public enum ResponseFormat: String, CaseIterable, Codable {
        case text
        case json_object
    }

    public struct StreamOptions: Codable, Equatable {
        public var include_usage: Bool?

        public init(include_usage: Bool? = nil) {
            self.include_usage = include_usage
        }
    }

    public struct Tool: Codable, Equatable {
        public var type: String
        public var function: Function?

        public struct Function: Codable, Equatable {
            public var name: String
            public var description: String?
            public var parameters: JSONSchema?
            public var strict: Bool?

            public init(name: String, description: String? = nil, parameters: JSONSchema? = nil, strict: Bool? = nil) {
                self.name = name
                self.description = description
                self.parameters = parameters
                self.strict = strict
            }
        }

        public init(type: String, function: Function? = nil) {
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
    }

    public struct Message: Codable, Equatable {
        public var content: [Content]?
        public var refusal: String?
        public var role: Role
        public var name: String?
        public var audio: Audio?
        public var tool_calls: [ToolCall]?
        public var tool_call_id: String?

        public struct Content: Codable, Equatable {
            public var type: String
            public var text: String?
            public var image_url: ImageURL?
            public var input_audio: InputAudio?

            public struct ImageURL: Codable, Equatable {
                public var url: String
                public var detail: String?

                public init(url: String, detail: String? = nil) {
                    self.url = url
                    self.detail = detail
                }
            }

            public struct InputAudio: Codable, Equatable {
                public var data: String
                public var format: String

                public init(data: String, format: String) {
                    self.data = data
                    self.format = format
                }
            }

            public init(type: String, text: String? = nil, image_url: ImageURL? = nil, input_audio: InputAudio? = nil) {
                self.type = type
                self.text = text
                self.image_url = image_url
                self.input_audio = input_audio
            }
        }

        public enum Role: String, CaseIterable, Codable, Equatable {
            case developer
            case system
            case assistant
            case user
            case tool
        }

        public struct Audio: Codable, Equatable {
            public var id: String

            public init(id: String) {
                self.id = id
            }
        }

        public struct ToolCall: Codable, Equatable {
            public var id: String?
            public var type: String?
            public var function: Function

            public struct Function: Codable, Equatable {
                public var name: String?
                public var arguments: String?

                public init(name: String? = nil, arguments: String? = nil) {
                    self.name = name
                    self.arguments = arguments
                }
            }

            public init(id: String? = nil, type: String? = nil, function: Function) {
                self.id = id
                self.type = type
                self.function = function
            }
        }

        public init(content: [Content]? = nil, refusal: String? = nil, role: Role, name: String? = nil,
                    audio: Audio? = nil, tool_calls: [ToolCall]? = nil, tool_call_id: String? = nil) {
            self.content = content
            self.refusal = refusal
            self.role = role
            self.name = name
            self.audio = audio
            self.tool_calls = tool_calls
            self.tool_call_id = tool_call_id
        }

        public init(text: String? = nil, refusal: String? = nil, role: Role, name: String? = nil,
                    audio: Audio? = nil, tool_calls: [ToolCall]? = nil, tool_call_id: String? = nil) {
            self.content = (text != nil) ? [.init(type: "text", text: text)] : nil
            self.refusal = refusal
            self.role = role
            self.name = name
            self.audio = audio
            self.tool_calls = tool_calls
            self.tool_call_id = tool_call_id
        }
    }

    public init(messages: [Message], model: String, store: Bool? = nil, reasoning_effort: ReasoningEffort? = nil,
                frequency_penalty: Double? = nil, max_completion_tokens: Int? = nil, n: Int? = nil,
                modalities: [String]? = nil, audio: Audio? = nil, presence_penalty: Double? = nil,
                response_format: ResponseFormat? = nil, seed: Int? = nil, service_tier: String? = nil,
                stop: [String]? = nil, stream: Bool? = nil, stream_options: StreamOptions? = nil,
                temperature: Double? = nil, top_p: Double? = nil, tools: [Tool]? = nil, tool_choice: ToolChoice? = nil,
                parallel_tool_calls: Bool? = nil, user: String? = nil) {
        self.messages = messages
        self.model = model
        self.store = store
        self.reasoning_effort = reasoning_effort
        self.frequency_penalty = frequency_penalty
        self.max_completion_tokens = max_completion_tokens
        self.n = n
        self.modalities = modalities
        self.audio = audio
        self.presence_penalty = presence_penalty
        self.response_format = response_format
        self.seed = seed
        self.service_tier = service_tier
        self.stop = stop
        self.stream = stream
        self.stream_options = stream_options
        self.temperature = temperature
        self.top_p = top_p
        self.tools = tools
        self.tool_choice = tool_choice
        self.parallel_tool_calls = parallel_tool_calls
        self.user = user
    }
}

public struct ChatResponse: Codable, Equatable {
    public let id: String
    public let object: String
    public let created: TimeInterval
    public let model: String
    public let choices: [Choice]
    public let usage: Usage?
    public let system_fingerprint: String?
    public let service_tier: String?

    public struct Choice: Codable, Equatable {
        public let index: Int
        public let message: Message
        public let finish_reason: String?

        public struct Message: Codable, Equatable {
            public let content: String?
            public let refusal: String?
            public let tool_calls: [ToolCall]?
            public let role: String
            public let audio: Audio?

            public struct ToolCall: Codable, Equatable {
                public let index: Int
                public let id: String?
                public let type: String?
                public let function: Function

                public struct Function: Codable, Equatable {
                    public let name: String?
                    public let arguments: String
                }
            }

            public struct Audio: Codable, Equatable {
                public let id: String
                public let expires_at: Int
                public let data: String
                public let transcript: String
            }
        }
    }
}

public struct ChatStreamResponse: Codable, Equatable {
    public let id: String
    public let choices: [Choice]
    public let created: TimeInterval
    public let model: String
    public let service_tier: String?
    public let system_fingerprint: String?
    public let object: String
    public let usage: Usage?

    public struct Choice: Codable, Equatable {
        public let delta: Delta
        public let logprobs: LogProbs?
        public let finish_reason: String?
        public let index: Int

        public struct Delta: Codable, Equatable {
            public let content: String?
            public let tool_calls: [ChatResponse.Choice.Message.ToolCall]?
            public let role: String?
            public let refusal: String?
        }

        public struct LogProbs: Codable, Equatable {
            public let content: [Content]?
            public let refusal: [Content]?

            public struct Content: Codable, Equatable {
                public let token: String
                public let logprob: Double
                public let bytes: [Int]?
                public let top_logprobs: [Self]?
            }
        }
    }
}

extension ChatRequest.ToolChoice {

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

extension ChatRequest.Message {

    enum CodingKeys: String, CodingKey {
        case content
        case refusal
        case role
        case audio
        case name
        case tool_calls
        case tool_call_id
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let contentArray = try? container.decode([Content].self, forKey: .content) {
            self.content = contentArray
        } else if let contentString = try? container.decode(String.self, forKey: .content) {
            self.content = [Content(type: "text", text: contentString)]
        } else {
            self.content = nil
        }

        self.refusal = try container.decodeIfPresent(String.self, forKey: .refusal)
        self.role = try container.decode(Role.self, forKey: .role)
        self.audio = try container.decodeIfPresent(Audio.self, forKey: .audio)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.tool_calls = try container.decodeIfPresent([ToolCall].self, forKey: .tool_calls)
        self.tool_call_id = try container.decodeIfPresent(String.self, forKey: .tool_call_id)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        // Special handling for content
        if let content = content {
            // If there's exactly one content item of type "text", encode it as a string
            if content.count == 1,
                content[0].type == "text",
                let text = content[0].text
            {
                try container.encode(text, forKey: .content)
            } else {
                // Otherwise encode the full array
                try container.encode(content, forKey: .content)
            }
        }

        //try container.encodeIfPresent(content, forKey: .content)
        try container.encodeIfPresent(refusal, forKey: .refusal)
        try container.encode(role, forKey: .role)
        try container.encodeIfPresent(audio, forKey: .audio)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(tool_calls, forKey: .tool_calls)
        try container.encodeIfPresent(tool_call_id, forKey: .tool_call_id)
    }
}
