import Foundation

public struct ImagesQuery: Codable {
    /// A text description of the desired image(s). The maximum length is 1000 characters for dall-e-2 and 4000 characters for dall-e-3.
    public let prompt: String
    /// The model to use for image generation. Defaults to dall-e-2.
    public let model: String
    /// The number of images to generate. Must be between 1 and 10. For dall-e-3, only n=1 is supported.
    public let n: Int?
    /// The quality of the image that will be generated. hd creates images with finer details and greater consistency across the image. This param is only supported for dall-e-3.
    public let quality: String?
    /// The format in which the generated images are returned. Must be one of url or b64_json.
    public let responseFormat: ResponseFormat?
    /// The size of the generated images. Must be one of 256x256, 512x512, or 1024x1024 for dall-e-2. Must be one of 1024x1024, 1792x1024, or 1024x1792 for dall-e-3 models.
    public let size: String?
    /// The style of the generated images. Must be one of vivid or natural. Vivid causes the model to lean towards generating hyper-real and dramatic images. Natural causes the model to produce more natural, less hyper-real looking images. This param is only supported for dall-e-3.
    public let style: String?
    /// A unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse.
    public let user: String?

    public enum ResponseFormat: String, Codable {
        case url, b64_json
    }
    
    enum CodingKeys: String, CodingKey {
        case prompt
        case model
        case n
        case quality
        case responseFormat = "response_format"
        case size
        case style
        case user
    }
    
    public init(prompt: String, model: String, n: Int? = nil, quality: String? = nil, responseFormat: ResponseFormat? = nil, size: String? = nil, style: String? = nil, user: String? = nil) {
        self.prompt = prompt
        self.model = model
        self.n = n
        self.quality = quality
        self.responseFormat = responseFormat
        self.size = size
        self.style = style
        self.user = user
    }
}
