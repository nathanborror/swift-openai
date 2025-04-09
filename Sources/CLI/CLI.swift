import Foundation
import ArgumentParser
import OpenAI

@main
struct CLI: AsyncParsableCommand {

    static var configuration = CommandConfiguration(
        commandName: "openai",
        abstract: "A utility for interacting with the OpenAI API.",
        version: "0.0.1",
        subcommands: [
            Models.self,
            Chat.self,
            Transcribe.self,
        ]
    )
}

struct GlobalOptions: ParsableCommand {
    @Option(name: .shortAndLong, help: "Your API key.")
    var key: String

    @Option(name: .shortAndLong, help: "Model to use.")
    var model: String?
}

struct Models: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "models",
        abstract: "Returns available models."
    )

    @OptionGroup
    var global: GlobalOptions

    func run() async throws {
        let client = Client(apiKey: global.key)
        let resp = try await client.models()
        let out = resp.data.map { $0.id }.joined(separator: "\n")
        print(out)
    }
}

struct Chat: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "chat",
        abstract: "Returns a reponse to a chat prompt."
    )

    @OptionGroup
    var global: GlobalOptions

    @Option(name: .long, help: "Stream chat output.")
    var stream: Bool?

    func run() async throws {
        guard let model = global.model else {
            fatalError("Missing model argument")
        }
        let client = Client(apiKey: global.key)
        var messages: [ChatRequest.Message] = []

        write("\nUsing \(model)\n\n")

        while true {
            write("> ")
            guard let input = readLine(), !input.isEmpty else {
                continue
            }
            if input.lowercased() == "exit" {
                write("Exiting...")
                break
            }

            // Input message
            let message = ChatRequest.Message(text: input, role: .user)
            messages.append(message)

            // Input request
            let req = ChatRequest(
                messages: messages,
                model: model,
                stream: stream
            )

            // Handle response
            if let stream, stream {
                var text = ""
                for try await resp in try client.chatCompletionsStream(req) {
                    let delta = resp.choices.first?.delta.content ?? ""
                    text += delta
                    write(delta)
                }
                messages.append(.init(text: text, role: .assistant))
                newline()
            } else {
                let resp = try await client.chatCompletions(req)
                let text = resp.choices.first?.message.content ?? ""
                messages.append(.init(text: text, role: .assistant))
                write(text); newline()
            }
        }
    }

    func write(_ text: String?) {
        if let text, let data = text.data(using: .utf8) {
            FileHandle.standardOutput.write(data)
        }
    }

    func newline() {
        write("\n")
    }
}

struct Transcribe: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "transcribe",
        abstract: "Returns an audio transcription."
    )

    @OptionGroup
    var global: GlobalOptions

    @Argument(help: "Audio to transcribe.", completion: .file(), transform: URL.init(fileURLWithPath:))
    var file: URL

    func run() async throws {
        guard let model = global.model else {
            fatalError("Missing model argument")
        }
        let client = Client(apiKey: global.key)
        let request = TranscriptionRequest(
            file: file,
            model: model
        )
        let resp = try await client.transcriptions(request)
        print(resp)
    }
}
