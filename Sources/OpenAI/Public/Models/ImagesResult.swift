//
//  ImagesResult.swift
//  
//
//  Created by Sergii Kryvoblotskyi on 02/04/2023.
//

import Foundation

public struct ImagesResult: Codable, Equatable {
    
    public struct URLResult: Codable, Equatable {
        public let url: String
    }
    
    public let created: TimeInterval?
    public let data: [URLResult]?
    public let url: String?
    public let b64JSON: String?
    public let revisedPrompt: String?
    
    enum CodingKeys: String, CodingKey {
        case created
        case data
        case url
        case revisedPrompt = "revised_prompt"
        case b64JSON = "b64_json"
    }
}
