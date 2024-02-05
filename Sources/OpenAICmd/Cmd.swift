import Foundation
import ArgumentParser
import OpenAI

@main
struct Cmd: AsyncParsableCommand {
    
    static var configuration = CommandConfiguration(
        abstract: "A utility for interacting with the Anthropic API.",
        version: "0.0.1",
        subcommands: [
            ChatCompletion.self,
            ChatStreamCompletion.self,
            ChatVisionCompletion.self,
            ChatVisionStreamCompletion.self,
        ]
    )
}

struct Options: ParsableArguments {
    @Option(help: "Your API token.")
    var token = ""
    
    @Option(help: "Model to use.")
    var model = ""
    
    @Option(help: "Max tokens limit.")
    var maxTokens = 0
    
    @Argument(help: "Your messages.")
    var prompt = ""
}

struct ChatCompletion: AsyncParsableCommand {
    static var configuration = CommandConfiguration(abstract: "Completes a chat request.")
    
    @OptionGroup var options: Options
    
    func run() async throws {
        let client = OpenAIClient(token: options.token)
        let query = ChatQuery(model: options.model, messages: [.init(role: .user, content: options.prompt)])
        let message = try await client.chats(query: query)
        if let content = message.choices.first?.message.content, let data = content.data(using: .utf8) {
            try FileHandle.standardOutput.write(contentsOf: data)
        }
    }
}

struct ChatStreamCompletion: AsyncParsableCommand {
    static var configuration = CommandConfiguration(abstract: "Completes a chat request, streaming the response.")
    
    @OptionGroup var options: Options
    
    func run() async throws {
        let client = OpenAIClient(token: options.token)
        let query = ChatQuery(model: options.model, messages: [.init(role: .user, content: options.prompt)])
        let stream: AsyncThrowingStream<ChatStreamResult, Error> = client.chatsStream(query: query)
        for try await result in stream {
            if let content = result.choices.first?.delta.content, let data = content.data(using: .utf8) {
                try FileHandle.standardOutput.write(contentsOf: data)
            }
        }
    }
}

struct ChatVisionCompletion: AsyncParsableCommand {
    static var configuration = CommandConfiguration(abstract: "Completes a chat vision request.")
    
    @OptionGroup var options: Options
    
    func run() async throws {
        let client = OpenAIClient(token: options.token)
        let query = ChatVisionQuery(
            model: options.model,
            messages: [
                .text(.init(role: .system, content: "You are a helpful assistant.")),
                .text(.init(role: .assistant, content: "I am a helpful assistant.")),
                .vision(.init(role: .user, content: [
                    .init(type: "image_url", imageURL: .init(url: "https://nathan.run/screenshots/2012-facebook-poke.png")),
                    .init(type: "text", text: options.prompt)
                ]))
            ],
            maxTokens: (options.maxTokens == 0) ? nil : options.maxTokens
        )
        let message = try await client.chatsVision(query: query)
        if let content = message.choices.first?.message.content, let data = content.data(using: .utf8) {
            try FileHandle.standardOutput.write(contentsOf: data)
        }
    }
}

struct ChatVisionStreamCompletion: AsyncParsableCommand {
    static var configuration = CommandConfiguration(abstract: "Completes a chat vision request, streaming the response.")
    
    @OptionGroup var options: Options
    
    func run() async throws {
        let client = OpenAIClient(token: options.token)
        let query = ChatVisionQuery(
            model: options.model,
            messages: [
                .text(.init(role: .system, content: "You are a helpful assistant.")),
                .text(.init(role: .assistant, content: "I am a helpful assistant.")),
                .vision(.init(role: .user, content: [
                    .init(type: "image_url", imageURL: .init(url: "https://nathan.run/screenshots/2012-facebook-poke.png")),
                    .init(type: "text", text: options.prompt)
                ]))
            ],
            maxTokens: (options.maxTokens == 0) ? nil : options.maxTokens
        )
        let stream: AsyncThrowingStream<ChatStreamResult, Error> = client.chatsVisionStream(query: query)
        for try await result in stream {
            if let content = result.choices.first?.delta.content, let data = content.data(using: .utf8) {
                try FileHandle.standardOutput.write(contentsOf: data)
            }
        }
    }
}
