import Foundation

public struct AudioTranslationQuery: Codable, Equatable {
    public let file: Data
    public let fileName: String
    public let model: String
    public let prompt: String?
    public let temperature: Double?
    public let responseFormat: ResponseFormat?
    
    public enum ResponseFormat: String, Codable {
        case json, text, srt, verbose_json, vtt
    }
    
    enum CodingKeys: String, CodingKey {
        case file
        case fileName
        case model
        case prompt
        case temperature
        case responseFormat = "response_format"
    }
    
    public init(file: Data, fileName: String, model: String, prompt: String? = nil, temperature: Double? = nil, responseFormat: ResponseFormat? = nil) {
        self.file = file
        self.fileName = fileName
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
