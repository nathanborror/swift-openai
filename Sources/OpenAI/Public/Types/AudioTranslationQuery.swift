import Foundation

public struct AudioTranslationQuery: Codable, Equatable {
    public let file: Data
    public let model: String
    public let prompt: String?
    public let temperature: Float?
    public let responseFormat: ResponseFormat?
    
    public enum ResponseFormat: String, Codable {
        case json, text, srt, verbose_json, vtt
    }
    
    enum CodingKeys: String, CodingKey {
        case file
        case model
        case prompt
        case temperature
        case responseFormat = "response_format"
    }
    
    public init(file: Data, model: String, prompt: String? = nil, temperature: Float? = nil, responseFormat: ResponseFormat? = nil) {
        self.file = file
        self.model = model
        self.prompt = prompt
        self.temperature = temperature
        self.responseFormat = responseFormat
    }
}

extension AudioTranslationQuery: MultipartFormDataBodyEncodable {
    
    func encode(boundary: String) -> Data {
        let bodyBuilder = MultipartFormDataBodyBuilder(boundary: boundary, entries: [
            .file(paramName: "file", fileData: file, contentType: "audio/mpeg"),
            .string(paramName: "model", value: model),
            .string(paramName: "prompt", value: prompt),
            .string(paramName: "temperature", value: temperature),
            .string(paramName: "response_format", value: responseFormat?.rawValue)
        ])
        return bodyBuilder.build()
    }
}
