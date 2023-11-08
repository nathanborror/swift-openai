//
//  ChatQuery.swift
//  
//
//  Created by Sergii Kryvoblotskyi on 02/04/2023.
//

import Foundation

public struct Chat: Codable, Equatable {
    public let role: Role
    /// The contents of the message. `content` is required for all messages except assistant messages with function calls.
    public let content: String?
    /// The name of the author of this message. `name` is required if role is `function`, and it should be the name of the function whose response is in the `content`. May contain a-z, A-Z, 0-9, and underscores, with a maximum length of 64 characters.
    public let name: String?
    /// The tool calls generated by the model, such as function calls.
    public let toolCalls: [ToolCall]?
    /// Tool call that this message is responding to.
    public let toolCallID: String?
    
    public enum Role: String, Codable, Equatable {
        case system
        case assistant
        case user
        case tool
    }
    
    public struct ToolCall: Codable, Equatable {
        public let id: String?
        public let type: String?
        public let function: Function
        public let index: Int?
        
        public struct Function: Codable, Equatable {
            public let name: String?
            public let arguments: String?
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case role
        case content
        case name
        case toolCalls = "tool_calls"
        case toolCallID = "tool_call_id"
    }
    
    public init(role: Role, content: String? = nil, name: String? = nil, toolCalls: [ToolCall]? = nil, toolCallID: String? = nil) {
        self.role = role
        self.content = content
        self.name = name
        self.toolCalls = toolCalls
        self.toolCallID = toolCallID
    }
}

public struct ChatQuery: Equatable, Codable, Streamable {
    /// ID of the model to use. Currently, only gpt-3.5-turbo and gpt-3.5-turbo-0301 are supported.
    public let model: Model
    /// The messages to generate chat completions for
    public let messages: [Chat]
    /// A list of tools the model may call. Currently, only functions are supported as a tool.
    public let tools: [Tool]?
    /// Controls which (if any) function is called by the model.
    public let toolChoice: ToolChoice?
    /// What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and  We generally recommend altering this or top_p but not both.
    public let temperature: Double?
    /// An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of the tokens with top_p probability mass. So 0.1 means only the tokens comprising the top 10% probability mass are considered.
    public let topP: Double?
    /// How many chat completion choices to generate for each input message.
    public let n: Int?
    /// An object specifying the format that the model must output. Used to enable JSON mode.
    public let responseFormat: ResponseFormat?
    /// If specified, our system will make a best effort to sample deterministically, such that repeated requests with the same seed and parameters should return the same result.
    public let seed: Int?
    /// Up to 4 sequences where the API will stop generating further tokens. The returned text will not contain the stop sequence.
    public let stop: [String]?
    /// The maximum number of tokens to generate in the completion.
    public let maxTokens: Int?
    /// Number between -2.0 and 2.0. Positive values penalize new tokens based on whether they appear in the text so far, increasing the model's likelihood to talk about new topics.
    public let presencePenalty: Double?
    /// Number between -2.0 and 2.0. Positive values penalize new tokens based on their existing frequency in the text so far, decreasing the model's likelihood to repeat the same line verbatim.
    public let frequencyPenalty: Double?
    /// Modify the likelihood of specified tokens appearing in the completion.
    public let logitBias: [String:Int]?
    /// A unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse.
    public let user: String?
    
    var stream: Bool = false

    public enum ResponseFormat: String, Codable {
        case text
        case json = "json_object"
    }
    
    public struct Tool: Codable, Equatable {
        public let type: String
        public let function: Function
        
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
    
    public init(model: Model, messages: [Chat], tools: [Tool]? = nil, toolChoice: ToolChoice? = nil, temperature: Double? = nil, topP: Double? = nil, n: Int? = nil, responseFormat: ResponseFormat? = nil, seed: Int? = nil, stop: [String]? = nil, maxTokens: Int? = nil, presencePenalty: Double? = nil, frequencyPenalty: Double? = nil, logitBias: [String : Int]? = nil, user: String? = nil, stream: Bool = false) {
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

/// See the [guide](/docs/guides/gpt/function-calling) for examples, and the [JSON Schema reference](https://json-schema.org/understanding-json-schema/) for documentation about the format.
public struct JSONSchema: Codable, Equatable {
    public let type: JSONType
    public let properties: [String: Property]?
    public let required: [String]?
    public let pattern: String?
    public let const: String?
    public let enumValues: [String]?
    public let multipleOf: Int?
    public let minimum: Int?
    public let maximum: Int?
    
    private enum CodingKeys: String, CodingKey {
        case type, properties, required, pattern, const
        case enumValues = "enum"
        case multipleOf, minimum, maximum
    }
    
    public struct Property: Codable, Equatable {
        public let type: JSONType
        public let description: String?
        public let format: String?
        public let items: Items?
        public let required: [String]?
        public let pattern: String?
        public let const: String?
        public let enumValues: [String]?
        public let multipleOf: Int?
        public let minimum: Double?
        public let maximum: Double?
        public let minItems: Int?
        public let maxItems: Int?
        public let uniqueItems: Bool?

        private enum CodingKeys: String, CodingKey {
            case type, description, format, items, required, pattern, const
            case enumValues = "enum"
            case multipleOf, minimum, maximum
            case minItems, maxItems, uniqueItems
        }
        
        public init(type: JSONType, description: String? = nil, format: String? = nil, items: Items? = nil, required: [String]? = nil, pattern: String? = nil, const: String? = nil, enumValues: [String]? = nil, multipleOf: Int? = nil, minimum: Double? = nil, maximum: Double? = nil, minItems: Int? = nil, maxItems: Int? = nil, uniqueItems: Bool? = nil) {
            self.type = type
            self.description = description
            self.format = format
            self.items = items
            self.required = required
            self.pattern = pattern
            self.const = const
            self.enumValues = enumValues
            self.multipleOf = multipleOf
            self.minimum = minimum
            self.maximum = maximum
            self.minItems = minItems
            self.maxItems = maxItems
            self.uniqueItems = uniqueItems
        }
    }

    public enum JSONType: String, Codable {
        case integer = "integer"
        case string = "string"
        case boolean = "boolean"
        case array = "array"
        case object = "object"
        case number = "number"
        case `null` = "null"
    }

    public struct Items: Codable, Equatable {
        public let type: JSONType
        public let properties: [String: Property]?
        public let pattern: String?
        public let const: String?
        public let enumValues: [String]?
        public let multipleOf: Int?
        public let minimum: Double?
        public let maximum: Double?
        public let minItems: Int?
        public let maxItems: Int?
        public let uniqueItems: Bool?

        private enum CodingKeys: String, CodingKey {
            case type, properties, pattern, const
            case enumValues = "enum"
            case multipleOf, minimum, maximum, minItems, maxItems, uniqueItems
        }
        
        public init(type: JSONType, properties: [String : Property]? = nil, pattern: String? = nil, const: String? = nil, enumValues: [String]? = nil, multipleOf: Int? = nil, minimum: Double? = nil, maximum: Double? = nil, minItems: Int? = nil, maxItems: Int? = nil, uniqueItems: Bool? = nil) {
            self.type = type
            self.properties = properties
            self.pattern = pattern
            self.const = const
            self.enumValues = enumValues
            self.multipleOf = multipleOf
            self.minimum = minimum
            self.maximum = maximum
            self.minItems = minItems
            self.maxItems = maxItems
            self.uniqueItems = uniqueItems
        }
    }
    
    public init(type: JSONType, properties: [String : Property]? = nil, required: [String]? = nil, pattern: String? = nil, const: String? = nil, enumValues: [String]? = nil, multipleOf: Int? = nil, minimum: Int? = nil, maximum: Int? = nil) {
        self.type = type
        self.properties = properties
        self.required = required
        self.pattern = pattern
        self.const = const
        self.enumValues = enumValues
        self.multipleOf = multipleOf
        self.minimum = minimum
        self.maximum = maximum
    }
}
