import XCTest
@testable import OpenAI

class OpenAITests: XCTestCase {

    var openAI: OpenAIProtocol!
    var urlSession: URLSessionMock!
    
    override func setUp() {
        super.setUp()
        self.urlSession = URLSessionMock()
        let configuration = OpenAI.Configuration(token: "foo", organizationIdentifier: "bar", timeoutInterval: 14)
        self.openAI = OpenAI(configuration: configuration, session: self.urlSession)
    }
    
    func testCompletions() async throws {
        let query = CompletionsQuery(model: "gpt-3.5-turbo-instruct", prompt: "What is 42?", temperature: 0, maxTokens: 100, topP: 1, frequencyPenalty: 0, presencePenalty: 0, stop: ["\\n"])
        let expectedResult = CompletionsResult(id: "foo", object: "bar", created: 100500, model: "gpt-3.5-turbo-instruct", choices: [
            .init(text: "42 is the answer to everything", index: 0, finishReason: nil)
        ], usage: .init(promptTokens: 10, completionTokens: 10, totalTokens: 20))
        try self.stub(result: expectedResult)
        
        let result = try await openAI.completions(query: query)
        XCTAssertEqual(result, expectedResult)
    }
    
    func testCompletionsAPIError() async throws {
        let query = CompletionsQuery(model: "gpt-3.5-turbo-instruct", prompt: "What is 42?", temperature: 0, maxTokens: 100, topP: 1, frequencyPenalty: 0, presencePenalty: 0, stop: ["\\n"])
        let inError = APIError(message: "foo", type: "bar", param: "baz", code: "100")
        self.stub(error: inError)
        
        let apiError: APIError = try await XCTExpectError { try await openAI.completions(query: query) }
        XCTAssertEqual(inError, apiError)
    }
    
    func testImages() async throws {
        let query = ImagesQuery(prompt: "White cat with heterochromia sitting on the kitchen table", model: "dall-e-2", n: 1, size: "1024x1024")
        let imagesResult = ImagesResult(created: 100, data: [
            .init(url: "http://foo.bar", b64JSON: nil, revisedPrompt: nil),
        ])
        try self.stub(result: imagesResult)
        let result = try await openAI.images(query: query)
        XCTAssertEqual(result, imagesResult)
    }
    
    func testImagesError() async throws {
        let query = ImagesQuery(prompt: "White cat with heterochromia sitting on the kitchen table", model: "dall-e-2", n: 1, size: "1024x1024")
        let inError = APIError(message: "foo", type: "bar", param: "baz", code: "100")
        self.stub(error: inError)
        
        let apiError: APIError = try await XCTExpectError { try await openAI.images(query: query) }
        XCTAssertEqual(inError, apiError)
    }
    
    func testChats() async throws {
        let query = ChatQuery(model: "gpt-3.5-turbo", messages: [
            .init(role: .system, content: "You are Librarian-GPT. You know everything about the books."),
            .init(role: .user, content: "Who wrote Harry Potter?")
        ])
        let chatResult = ChatResult(
            id: "id-12312",
            object: "foo",
            created: 100,
            model: "gpt-3.5-turbo",
            choices: [
                .init(index: 0, message: .init(role: .system, content: "bar"), finishReason: "baz"),
                .init(index: 0, message: .init(role: .user, content: "bar1"), finishReason: "baz1"),
                .init(index: 0, message: .init(role: .assistant, content: "bar2"), finishReason: "baz2"),
            ],
            usage: .init(promptTokens: 100, completionTokens: 200, totalTokens: 300),
            systemFingerprint: ""
        )
        try self.stub(result: chatResult)
        
        let result = try await openAI.chats(query: query)
        print(result)
        XCTAssertEqual(result, chatResult)
    }

    func testChatsFunction() async throws {
        let query = ChatQuery(
            model: "gpt-3.5-turbo",
            messages: [
                .init(role: .system, content: "You are Weather-GPT. You know everything about the weather."),
                .init(role: .user, content: "What's the weather like in Boston?"),
            ],
            tools: [
                .init(
                    type: "function",
                    function: .init(
                        name: "get_current_weather",
                        description: "Get the current weather in a given location",
                        parameters: .init(
                            type: .object,
                            properties: [
                                "location": .init(type: .string, description: "The city and state, e.g. San Francisco, CA"),
                                "unit": .init(type: .string, enumValues: ["celsius", "fahrenheit"])
                            ], 
                            required: ["location"]
                        )
                    )
                )
            ],
            toolChoice: .auto
        )
        let chatResult = ChatResult(
            id: "id-12312",
            object: "foo",
            created: 100,
            model: "gpt-3.5-turbo",
            choices: [
                .init(index: 0, message: .init(role: .system, content: "bar"), finishReason: "baz"),
                .init(index: 0, message: .init(role: .user, content: "bar1"), finishReason: "baz1"),
                .init(index: 0, message: .init(role: .assistant, content: "bar2"), finishReason: "baz2"),
            ],
            usage: .init(promptTokens: 100, completionTokens: 200, totalTokens: 300),
            systemFingerprint: ""
        )
        try self.stub(result: chatResult)
        
        let result = try await openAI.chats(query: query)
        XCTAssertEqual(result, chatResult)
    }
    
    func testChatsError() async throws {
        let query = ChatQuery(model: "gpt-3.5-turbo", messages: [
            .init(role: .system, content: "You are Librarian-GPT. You know everything about the books."),
            .init(role: .user, content: "Who wrote Harry Potter?")
        ])
        let inError = APIError(message: "foo", type: "bar", param: "baz", code: "100")
        self.stub(error: inError)

        let apiError: APIError = try await XCTExpectError { try await openAI.chats(query: query) }
        XCTAssertEqual(inError, apiError)
    }
    
    func testEdits() async throws {
        let query = EditsQuery(model: "gpt-3.5-turbo", input: "What day of the wek is it?", instruction: "Fix the spelling mistakes")
        let editsResult = EditsResult(object: "edit", created: 1589478378, choices: [
            .init(text: "What day of the week is it?", index: 0)
        ], usage: .init(promptTokens: 25, completionTokens: 32, totalTokens: 57))
        try self.stub(result: editsResult)
        
        let result = try await openAI.edits(query: query)
        XCTAssertEqual(result, editsResult)
    }
    
    func testEditsError() async throws {
        let query = EditsQuery(model: "gpt-3.5-turbo", input: "What day of the wek is it?", instruction: "Fix the spelling mistakes")
        let inError = APIError(message: "foo", type: "bar", param: "baz", code: "100")
        self.stub(error: inError)

        let apiError: APIError = try await XCTExpectError { try await openAI.edits(query: query) }
        XCTAssertEqual(inError, apiError)
    }
    
    func testEmbeddings() async throws {
        let query = EmbeddingsQuery(model: "text-embedding-ada-002", input: "The food was delicious and the waiter...")
        let embeddingsResult = EmbeddingsResult(data: [
            .init(object: "id-sdasd", embedding: [0.1, 0.2, 0.3, 0.4], index: 0),
            .init(object: "id-sdasd1", embedding: [0.4, 0.1, 0.7, 0.1], index: 1),
            .init(object: "id-sdasd2", embedding: [0.8, 0.1, 0.2, 0.8], index: 2)
        ], model: "text-embedding-ada-002", usage: .init(promptTokens: 10, completionTokens: nil, totalTokens: 10))
        try self.stub(result: embeddingsResult)
        
        let result = try await openAI.embeddings(query: query)
        XCTAssertEqual(result, embeddingsResult)
    }
    
    func testEmbeddingsError() async throws {
        let query = EmbeddingsQuery(model: "text-embedding-ada-002", input: "The food was delicious and the waiter...")
        let inError = APIError(message: "foo", type: "bar", param: "baz", code: "100")
        self.stub(error: inError)

        let apiError: APIError = try await XCTExpectError { try await openAI.embeddings(query: query) }
        XCTAssertEqual(inError, apiError)
    }
    
    func testRetrieveModel() async throws {
        let query = ModelQuery(model: "gpt-3.5-turbo")
        let modelResult = ModelResult(id: "gpt-3.5-turbo", object: "model", ownedBy: "organization-owner")
        try self.stub(result: modelResult)
        
        let result = try await openAI.model(query: query)
        XCTAssertEqual(result, modelResult)
    }
    
    func testRetrieveModelError() async throws {
        let query = ModelQuery(model: "gpt-3.5-turbo")
        let inError = APIError(message: "foo", type: "bar", param: "baz", code: "100")
        self.stub(error: inError)
        
        let apiError: APIError = try await XCTExpectError { try await openAI.model(query: query) }
        XCTAssertEqual(inError, apiError)
    }
    
    func testListModels() async throws {
        let listModelsResult = ModelsResult(data: [
            .init(id: "model-id-0", object: "model", ownedBy: "organization-owner"),
            .init(id: "model-id-1", object: "model", ownedBy: "organization-owner"),
            .init(id: "model-id-2", object: "model", ownedBy: "openai")
        ], object: "list")
        try self.stub(result: listModelsResult)
        
        let result = try await openAI.models()
        XCTAssertEqual(result, listModelsResult)
    }
    
    func testListModelsError() async throws {
        let inError = APIError(message: "foo", type: "bar", param: "baz", code: "100")
        self.stub(error: inError)
        
        let apiError: APIError = try await XCTExpectError { try await openAI.models() }
        XCTAssertEqual(inError, apiError)
    }
    
    func testModerations() async throws {
        let query = ModerationsQuery(input: "Hello, world!")
        let moderationsResult = ModerationsResult(id: "foo", model: "text-moderation-stable", results: [
            .init(categories: .init(hate: false, hateThreatening: false, selfHarm: false, sexual: false, sexualMinors: false, violence: false, violenceGraphic: false),
                  categoryScores: .init(hate: 0.1, hateThreatening: 0.1, selfHarm: 0.1, sexual: 0.1, sexualMinors: 0.1, violence: 0.1, violenceGraphic: 0.1),
                  flagged: false)
        ])
        try self.stub(result: moderationsResult)
        
        let result = try await openAI.moderations(query: query)
        XCTAssertEqual(result, moderationsResult)
    }
    
    func testModerationsError() async throws {
        let query = ModerationsQuery(input: "Hello, world!")
        let inError = APIError(message: "foo", type: "bar", param: "baz", code: "100")
        self.stub(error: inError)
        
        let apiError: APIError = try await XCTExpectError { try await openAI.moderations(query: query) }
        XCTAssertEqual(inError, apiError)
    }
    
    func testAudioTranscriptions() async throws {
        let data = Data()
        let query = AudioTranscriptionQuery(file: data, model: "whisper-1")
        let transcriptionResult = AudioTranscriptionResult(text: "Hello, world!")
        try self.stub(result: transcriptionResult)
        
        let result = try await openAI.audioTranscriptions(query: query)
        XCTAssertEqual(result, transcriptionResult)
    }
    
    func testAudioTranscriptionsError() async throws {
        let data = Data()
        let query = AudioTranscriptionQuery(file: data, model: "whisper-1")
        let inError = APIError(message: "foo", type: "bar", param: "baz", code: "100")
        self.stub(error: inError)
        
        let apiError: APIError = try await XCTExpectError { try await openAI.audioTranscriptions(query: query) }
        XCTAssertEqual(inError, apiError)
    }
    
    func testAudioTranslations() async throws {
        let data = Data()
        let query = AudioTranslationQuery(file: data, model: "whisper-1")
        let transcriptionResult = AudioTranslationResult(text: "Hello, world!")
        try self.stub(result: transcriptionResult)
        
        let result = try await openAI.audioTranslations(query: query)
        XCTAssertEqual(result, transcriptionResult)
    }
    
    func testAudioTranslationsError() async throws {
        let data = Data()
        let query = AudioTranslationQuery(file: data, model: "whisper-1")
        let inError = APIError(message: "foo", type: "bar", param: "baz", code: "100")
        self.stub(error: inError)
        
        let apiError: APIError = try await XCTExpectError { try await openAI.audioTranslations(query: query) }
        XCTAssertEqual(inError, apiError)
    }
    
    func testSimilarity_Similar() {
        let vector1 = [0.213123, 0.3214124, 0.1414124, 0.3214521251, 0.213123, 0.3214124, 0.1414124, 0.3214521251, 0.213123, 0.3214124, 0.1414124, 0.3214521251, 0.213123, 0.3214124, 0.1414124, 0.3214521251, 0.213123, 0.3214124, 0.1414124, 0.3214521251]
        let vector2 = [0.213123, 0.3214124, 0.1414124, 0.3214521251, 0.213123, 0.3214124, 0.1414124, 0.3214521251, 0.213123, 0.3214124, 0.1414124, 0.3214521251, 0.213123, 0.3214124, 0.1414124, 0.3214521251, 0.213123, 0.3214124, 0.1414124, 0.3214521251]
        let similarity = Vector.cosineSimilarity(a: vector1, b: vector2)
        XCTAssertEqual(similarity, 1.0, accuracy: 0.000001)
    }

    func testSimilarity_NotSimilar() {
        let vector1 = [0.213123, 0.3214124, 0.421412, 0.3214521251, 0.412412, 0.3214124, 0.1414124, 0.3214521251, 0.213123, 0.3214124, 0.1414124, 0.4214214, 0.213123, 0.3214124, 0.1414124, 0.3214521251, 0.213123, 0.3214124, 0.1414124, 0.3214521251]
        let vector2 = [0.213123, 0.3214124, 0.1414124, 0.3214521251, 0.213123, 0.3214124, 0.1414124, 0.3214521251, 0.213123, 0.511515, 0.1414124, 0.3214521251, 0.213123, 0.3214124, 0.1414124, 0.3214521251, 0.213123, 0.3214124, 0.1414124, 0.3213213]
        let similarity = Vector.cosineSimilarity(a: vector1, b: vector2)
        XCTAssertEqual(similarity, 0.9510201910206734, accuracy: 0.000001)
    }
    
    func testJSONRequestCreation() throws {
        let configuration = OpenAI.Configuration(token: "foo", organizationIdentifier: "bar", timeoutInterval: 14)
        let completionQuery = CompletionsQuery(model: "whisper-1", prompt: "how are you?")
        let jsonRequest = JSONRequest<CompletionsResult>(body: completionQuery, url: URL(string: "http://google.com")!)
        let urlRequest = try jsonRequest.build(token: configuration.token, organizationIdentifier: configuration.organizationIdentifier, timeoutInterval: configuration.timeoutInterval)
        
        XCTAssertEqual(urlRequest.value(forHTTPHeaderField: "Authorization"), "Bearer \(configuration.token)")
        XCTAssertEqual(urlRequest.value(forHTTPHeaderField: "Content-Type"), "application/json")
        XCTAssertEqual(urlRequest.value(forHTTPHeaderField: "OpenAI-Organization"), configuration.organizationIdentifier)
        XCTAssertEqual(urlRequest.timeoutInterval, configuration.timeoutInterval)
    }
    
    func testMultipartRequestCreation() throws {
        let configuration = OpenAI.Configuration(token: "foo", organizationIdentifier: "bar", timeoutInterval: 14)
        let completionQuery = AudioTranslationQuery(file: Data(), model: "whisper-1")
        let jsonRequest = MultipartFormDataRequest<CompletionsResult>(body: completionQuery, url: URL(string: "http://google.com")!)
        let urlRequest = try jsonRequest.build(token: configuration.token, organizationIdentifier: configuration.organizationIdentifier, timeoutInterval: configuration.timeoutInterval)
        
        XCTAssertEqual(urlRequest.value(forHTTPHeaderField: "Authorization"), "Bearer \(configuration.token)")
        XCTAssertEqual(urlRequest.value(forHTTPHeaderField: "OpenAI-Organization"), configuration.organizationIdentifier)
        XCTAssertEqual(urlRequest.timeoutInterval, configuration.timeoutInterval)
    }
    
    func testDefaultHostURLBuilt() {
        let configuration = OpenAI.Configuration(token: "foo", organizationIdentifier: "bar", timeoutInterval: 14)
        let openAI = OpenAI(configuration: configuration, session: self.urlSession)
        let completionsURL = openAI.buildURL(path: "completions")
        XCTAssertEqual(completionsURL, URL(string: "https://api.openai.com/v1/completions"))
    }
    
    func testCustomURLBuilt() {
        let configuration = OpenAI.Configuration(token: "foo", organizationIdentifier: "bar", host: URL(string: "http://my.host.com")!, timeoutInterval: 14)
        let openAI = OpenAI(configuration: configuration, session: self.urlSession)
        let completionsURL = openAI.buildURL(path: "completions")
        XCTAssertEqual(completionsURL, URL(string: "https://my.host.com/v1/completions"))
    }
}

extension OpenAITests {
    
    func stub(error: Error) {
        let error = APIError(message: "foo", type: "bar", param: "baz", code: "100")
        let task = DataTaskMock.failed(with: error)
        self.urlSession.dataTask = task
    }
    
    func stub(result: Codable) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(result)
        let task = DataTaskMock.successful(with: data)
        self.urlSession.dataTask = task
    }
}

extension OpenAITests {
    
    enum TypeError: Error {
        case unexpectedResult(String)
        case typeMismatch(String)
    }
    
    func XCTExpectError<ErrorType: Error>(execute: () async throws -> Any) async throws -> ErrorType {
        do {
            let result = try await execute()
            throw TypeError.unexpectedResult("Error expected, but result is returned \(result)")
        } catch {
            guard let apiError = error as? ErrorType else {
                throw TypeError.typeMismatch("Expected APIError, got instead: \(error)")
            }
            return apiError
        }
    }
}
