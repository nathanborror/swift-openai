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
        ]
    )
}

struct Options: ParsableArguments {
    @Option(help: "Your API token.")
    var token = ""
    
    @Option(help: "Model to use.")
    var model = ""
    
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
        print(message.choices.first?.message.content ?? "")
    }
}

struct ChatStreamCompletion: AsyncParsableCommand {
    static var configuration = CommandConfiguration(abstract: "Completes a chat request, streaming the response.")
    
    @OptionGroup var options: Options
    
    func run() async throws {
        print("chat.stream.completion")
        print(options.prompt, options.token)
    }
}
