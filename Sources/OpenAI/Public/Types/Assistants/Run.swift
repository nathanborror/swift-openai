import Foundation

public struct Run: Codable {
    public var id: String
    public var object: String
    public var createdAt: Int
    public var threadID: String
    public var assistantID: String
    public var status: String
    public var requiredAction: Action?
    public var lastError: RunError?
    public var expiresAt: Int
    public var startedAt: Int?
    public var cancelledAt: Int?
    public var failedAt: Int?
    public var completedAt: Int?
    public var model: String
    public var instructions: String
    public var tools: [ChatQuery.Tool]
    public var fileIDs: [String]
    public var metadata: [String: String]
    
    public struct Action: Codable {
        public var type: String
        public var submitToolOutputs: ToolOutput
        
        public struct ToolOutput: Codable {
            public var toolCalls: [Chat.ToolCall]
            
            enum CodingKeys: String, CodingKey {
                case toolCalls = "tool_calls"
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case type
            case submitToolOutputs = "submit_tool_outputs"
        }
    }
    
    public struct RunError: Codable {
        public var code: String
        public var message: String
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case object
        case createdAt = "created_at"
        case threadID = "thread_id"
        case assistantID = "assistant_id"
        case status
        case requiredAction = "required_action"
        case lastError = "last_error"
        case expiresAt = "expires_at"
        case startedAt = "started_at"
        case cancelledAt = "cancelled_at"
        case failedAt = "failed_at"
        case completedAt = "completed_at"
        case model
        case instructions
        case tools
        case fileIDs = "file_ids"
        case metadata
    }
}
