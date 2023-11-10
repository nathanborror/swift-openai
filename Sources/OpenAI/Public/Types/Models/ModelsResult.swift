import Foundation

public struct ModelsResult: Codable, Equatable {
    public let data: [ModelResult]
    public let object: String
}
