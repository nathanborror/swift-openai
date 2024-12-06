import Foundation
import ArgumentParser
import OpenAI
import SharedKit

@main
struct Command: AsyncParsableCommand {

    static var configuration = CommandConfiguration(
        abstract: "A utility for interacting with the OpenAI API.",
        version: "0.0.1",
        subcommands: [
            ModelList.self,
            ChatCompletion.self,
        ],
        defaultSubcommand: ModelList.self
    )
}

struct GlobalOptions: ParsableCommand {
    @Option(name: .shortAndLong, help: "Your API key.")
    var key: String

    @Option(name: .shortAndLong, help: "Model to use.")
    var model = "gpt-4o"

    @Option(name: .shortAndLong, help: "System prompt.")
    var systemPrompt: String?

    var system: String?

    mutating func validate() throws {
        system = try ValueReader(input: systemPrompt)?.value()
    }
}

struct ModelList: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "models",
        abstract: "Returns available models."
    )

    @OptionGroup
    var global: GlobalOptions

    func run() async throws {
        let client = Client(apiKey: global.key)
        let resp = try await client.models()
        print(resp)
    }
}

struct ChatCompletion: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "complete",
        abstract: "Completes a chat request."
    )

    @OptionGroup
    var global: GlobalOptions

    func run() async throws {
        let client = Client(apiKey: global.key)
        var messages: [ChatRequest.Message] = []

        write("\nUsing \(global.model)\n\n")

        if let system = global.system {
            write("\n<system>\n\(system)\n</system>\n\n")
        }

        while true {
            write("> ")
            guard let input = readLine(), !input.isEmpty else {
                continue
            }
            if input.lowercased() == "exit" {
                write("Exiting...")
                break
            }

            let message = ChatRequest.Message(content: [.init(type: "text", text: input)], role: .user)
            messages.append(message)

            let req = ChatRequest(
                messages: messages,
                model: global.model
            )

            let resp = try await client.chatCompletions(req)
            let content = resp.choices.first?.message.content ?? ""
            write(content); newline()
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

// Helpers

enum ValueReader {
    case direct(String)
    case file(URL)

    init?(input: String?) throws {
        guard let input else { return nil }
        if FileManager.default.fileExists(atPath: input) {
            let url = URL(fileURLWithPath: input)
            self = .file(url)
        } else {
            self = .direct(input)
        }
    }

    func value() throws -> String {
        switch self {
        case .direct(let value):
            return value
        case .file(let url):
            return try String(contentsOf: url, encoding: .utf8)
        }
    }
}