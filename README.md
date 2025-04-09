<img src="Images/Animal.png" width="256">

# Swift OpenAI

An unofficial Swift client library for interacting with [OpenAI's API](https://platform.openai.com).

## Requirements

- Swift 5.9+
- iOS 16+
- macOS 13+
- watchOS 9+
- tvOS 16+

## Installation

Add the following to your `Package.swift` file:

```swift
Package(
    dependencies: [
        .package(url: "https://github.com/nathanborror/swift-openai", branch: "main"),
    ],
    targets: [
        .target(
            name: "YourApp",
            dependencies: [
                .product(name: "OpenAI", package: "swift-openai"),
            ]
        ),
    ]
)
```

## Usage

### Chat Completion

```swift
import OpenAI

let client = Client(apiKey: OPENAI_API_KEY)

let req = ChatRequest(
    messages: [.init(text: "Hello, OpenAI!", role: .user)],
    model: "gpt-4o"
)

do {
    let response = try await client.chatCompletions(request)
    print(response)
} catch {
    print(error)
}
```

### List models

```swift
import OpenAI

let client = Client(apiKey: OPENAI_API_KEY)

do {
    let response = try await client.models()
    print(response.data.map { $0.id }.joined(separator: "\n"))
} catch {
    print(error)
}
```

### Command Line Interface

```
$ make
$ ./openai
OVERVIEW: A utility for interacting with the OpenAI API.

USAGE: openai <subcommand>

OPTIONS:
  --version               Show the version.
  -h, --help              Show help information.

SUBCOMMANDS:
  models                  Returns available models.
  chat                    Returns a reponse to a chat prompt.
  transcribe              Returns an audio transcription.

  See 'cli help <subcommand>' for detailed help.
```
