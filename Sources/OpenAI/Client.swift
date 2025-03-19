import Foundation

public final class Client {

    public static let defaultHost = URL(string: "https://api.openai.com/v1")!

    public let host: URL
    public let apiKey: String

    internal(set) public var session: URLSession

    public init(session: URLSession = URLSession(configuration: .default), host: URL? = nil, apiKey: String) {
        self.session = session
        self.host = host ?? Self.defaultHost
        self.apiKey = apiKey
    }

    public enum Error: Swift.Error, CustomStringConvertible {
        case requestError(String)
        case responseError(response: HTTPURLResponse, detail: String)
        case decodingError(response: HTTPURLResponse, detail: String)
        case unexpectedError(String)

        public var description: String {
            switch self {
            case .requestError(let detail):
                return "Request error: \(detail)"
            case .responseError(let response, let detail):
                return "Response error (Status \(response.statusCode)): \(detail)"
            case .decodingError(let response, let detail):
                return "Decoding error (Status \(response.statusCode)): \(detail)"
            case .unexpectedError(let detail):
                return "Unexpected error: \(detail)"
            }
        }
    }

    private enum Method: String {
        case post = "POST"
        case get = "GET"
    }

    struct ErrorResponse: Decodable {
        let error: Error

        struct Error: Swift.Error, CustomStringConvertible, Decodable {
            let type: String
            let message: String
            let code: String?
            let params: String?

            public var description: String {
                "(\(type)) — \(message)"
            }
        }
    }
}

// MARK: - Models

extension Client {

    public func models() async throws -> ModelsResponse {
        try await fetch(.get, "models")
    }
}

// MARK: - Audio

extension Client {

    public func speech(_ request: SpeechRequest) async throws -> Data {
        try await fetch(.post, "audio/speech", body: request)
    }

    public func transcriptions(_ request: TranscriptionRequest) async throws -> TranscriptionResponse {
        try await fetch(.post, "audio/transcriptions", body: request, isMultipart: true)
    }

    public func translations(_ request: TranslationRequest) async throws -> TranslationResponse {
        try await fetch(.post, "audio/translations", body: request)
    }
}

// MARK: - Chats

extension Client {

    public func chatCompletions(_ request: ChatRequest) async throws -> ChatResponse {
        guard request.stream == nil || request.stream == false else {
            throw Error.requestError("ChatRequest.stream cannot be set to 'true'")
        }
        return try await fetch(.post, "chat/completions", body: request)
    }

    public func chatCompletionsStream(_ request: ChatRequest) throws -> AsyncThrowingStream<ChatStreamResponse, Swift.Error> {
        guard request.stream == true else {
            throw Error.requestError("ChatRequest.stream must be set to 'true'")
        }
        return try fetchAsync(.post, "chat/completions", body: request)
    }
}

// MARK: - Embeddings

extension Client {

    public func embeddings(_ request: EmbeddingsRequest) async throws -> EmbeddingsResponse {
        try await fetch(.post, "embeddings", body: request)
    }
}

// MARK: - Images

extension Client {

    public func imagesGenerations(_ request: ImageRequest) async throws -> ImageResponse {
        try await fetch(.post, "images/generations", body: request)
    }

    public func imagesEdits(_ request: ImageEditRequest) async throws -> ImageResponse {
        try await fetch(.post, "images/edits", body: request)
    }

    public func imagesVariations(_ request: ImageEditRequest) async throws -> ImageResponse {
        try await fetch(.post, "images/variations", body: request)
    }
}

// MARK: - Private

extension Client {

    private func fetch<Response: Decodable>(_ method: Method, _ path: String, body: Encodable? = nil, isMultipart: Bool = false) async throws -> Response {
        try checkAuthentication()
        let request = try makeRequest(path: path, method: method, body: body, isMultipart: isMultipart)
        let (data, resp) = try await session.data(for: request)
        try checkResponse(resp, data)
        return try decoder.decode(Response.self, from: data)
    }

    private func fetchAsync<Response: Codable>(_ method: Method, _ path: String, body: Encodable, isMultipart: Bool = false) throws -> AsyncThrowingStream<Response, Swift.Error> {
        try checkAuthentication()
        let request = try makeRequest(path: path, method: method, body: body, isMultipart: isMultipart)
        return AsyncThrowingStream { continuation in
            let session = StreamingSession<Response>(urlRequest: request)
            session.onReceiveContent = {_, object in
                continuation.yield(object)
            }
            session.onProcessingError = {_, error in
                continuation.finish(throwing: error)
            }
            session.onComplete = { object, error in
                continuation.finish(throwing: error)
            }
            session.perform()
        }
    }

    private func checkAuthentication() throws {
        if apiKey.isEmpty {
            throw Error.requestError("Missing API key")
        }
    }

    private func checkResponse(_ resp: URLResponse?, _ data: Data) throws {
        if let response = resp as? HTTPURLResponse, response.statusCode != 200 {
            if let err = try? decoder.decode(ErrorResponse.self, from: data) {
                throw Error.responseError(response: response, detail: err.error.message)
            } else {
                throw Error.responseError(response: response, detail: "Unknown response error")
            }
        }
    }

    private func makeRequest(path: String, method: Method, body: Encodable? = nil, isMultipart: Bool) throws -> URLRequest {
        var req = URLRequest(url: host.appending(path: path))
        req.httpMethod = method.rawValue
        req.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        if isMultipart {
            req.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
        } else {
            req.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }

        if let body {
            if isMultipart {
                let boundary = UUID().uuidString
                req.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

                var data = Data()

                let mirror = Mirror(reflecting: body)
                for child in mirror.children {
                    guard let name = child.label else { continue }

                    if let fileURL = child.value as? URL {
                        let filename = fileURL.lastPathComponent
                        let fileData = try Data(contentsOf: fileURL)

                        data.append("--\(boundary)\r\n".data(using: .utf8)!)
                        data.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
                        data.append("Content-Type: application/octet-stream\r\n\r\n".data(using: .utf8)!)
                        data.append(fileData)
                        data.append("\r\n".data(using: .utf8)!)
                    } else {
                        let value = String(describing: child.value)
                        if value != "nil" {
                            data.append("--\(boundary)\r\n".data(using: .utf8)!)
                            data.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
                            data.append("\(value)\r\n".data(using: .utf8)!)
                        }
                    }
                }

                data.append("--\(boundary)--\r\n".data(using: .utf8)!)
                req.httpBody = data
            } else {
                req.httpBody = try JSONEncoder().encode(body)
            }
        }
        return req
    }

    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateInt = try container.decode(Int.self)
            return Date(timeIntervalSince1970: TimeInterval(dateInt))
        }
        return decoder
    }
}
