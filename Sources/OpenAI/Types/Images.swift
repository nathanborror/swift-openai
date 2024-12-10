import Foundation

public struct ImageRequest: Codable, Sendable {
    public var prompt: String
    public var model: String?
    public var n: Int?
    public var quality: Quality?
    public var response_format: ResponseFormat?
    public var size: Size?
    public var style: Style?
    public var user: String?

    public enum Quality: String, CaseIterable, Codable, Sendable {
        case hd
    }

    public enum ResponseFormat: String, CaseIterable, Codable, Sendable {
        case url, b64_json
    }

    public enum Size: String, CaseIterable, Codable, Sendable {
        case size_256x256 = "256x256"
        case size_512x512 = "512x512"
        case size_1024x1024 = "1024x1024"
        case size_1024x1792 = "1024x1792"
        case size_1792x1024 = "1792x1024"
    }

    public enum Style: String, CaseIterable, Codable, Sendable {
        case vivid, natural
    }

    public init(prompt: String, model: String? = nil, n: Int? = nil, quality: Quality? = nil,
                response_format: ResponseFormat? = nil, size: Size? = nil, style: Style? = nil, user: String? = nil) {
        self.prompt = prompt
        self.model = model
        self.n = n
        self.quality = quality
        self.response_format = response_format
        self.size = size
        self.style = style
        self.user = user
    }
}

public struct ImageResponse: Codable, Sendable {
    public let created: Date
    public let data: [Image]

    public struct Image: Codable, Sendable {
        public let url: String?
        public let b64_json: String?
        public let revised_prompt: String?
    }
}

public struct ImageEditRequest: Codable, Sendable {
    public var image: Data
    public var prompt: String
    public var mask: Data?
    public var model: String?
    public var n: Int?
    public var size: Size?
    public var response_format: ResponseFormat?
    public var user: String?

    public enum Size: String, CaseIterable, Codable, Sendable {
        case size_256x256 = "256x256"
        case size_512x512 = "512x512"
        case size_1024x1024 = "1024x1024"
    }

    public enum ResponseFormat: String, CaseIterable, Codable, Sendable {
        case url, b64_json
    }

    public init(image: Data, prompt: String, mask: Data? = nil, model: String? = nil, n: Int? = nil, size: Size? = nil,
                response_format: ResponseFormat? = nil, user: String? = nil) {
        self.image = image
        self.prompt = prompt
        self.mask = mask
        self.model = model
        self.n = n
        self.size = size
        self.response_format = response_format
        self.user = user
    }
}

public struct ImageVariationRequest: Codable, Sendable {
    public var image: Data
    public var model: String?
    public var n: Int?
    public var response_format: ResponseFormat?
    public var size: Size?
    public var user: String?

    public enum ResponseFormat: String, CaseIterable, Codable, Sendable {
        case url, b64_json
    }

    public enum Size: String, CaseIterable, Codable, Sendable {
        case size_256x256 = "256x256"
        case size_512x512 = "512x512"
        case size_1024x1024 = "1024x1024"
    }
}
