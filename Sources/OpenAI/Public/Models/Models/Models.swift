//
//  Models.swift
//  
//
//  Created by Sergii Kryvoblotskyi on 12/19/22.
//

import Foundation

public typealias Model = String
public extension Model {
    
    // Chat Completions
    
    /// The latest GPT-4 model with improved instruction following, JSON mode, reproducible outputs, parallel function calling, and more. Returns a maximum of 4,096 output tokens. This preview model is not yet suited for production traffic.
    static let gpt4_1106_preview = "gpt-4-1106-preview"
    /// Ability to understand images, in addition to all other GPT-4 Turbo capabilties. Returns a maximum of 4,096 output tokens. This is a preview model version and not suited yet for production traffic.
    static let gpt4_vision_preview = "gpt-4-vision-preview"
    /// Currently points to gpt-4-0613
    static let gpt4 = "gpt-4"
    /// Snapshot of gpt-4 from June 13th 2023 with improved function calling support.
    static let gpt4_0613 = "gpt-4-0613"
    /// Currently points to gpt-4-32k-0613.
    static let gpt4_32k = "gpt-4-32k"
    /// Snapshot of gpt-4-32k from June 13th 2023 with improved function calling support.
    static let gpt4_32k_0613 = "gpt-4-32k-0613"
    /// Similar capabilities as text-davinci-003 but compatible with legacy Completions endpoint and not Chat Completions.
    static let gpt3_5TurboInstruct = "gpt-3.5-turbo-instruct"
    /// The latest GPT-3.5 Turbo model with improved instruction following, JSON mode, reproducible outputs, parallel function calling, and more. Returns a maximum of 4,096 output tokens.
    static let gpt3_5Turbo1106 = "gpt-3.5-turbo-1106"
    /// Currently points to gpt-3.5-turbo-0613. Will point to gpt-3.5-turbo-1106 starting Dec 11, 2023.
    static let gpt3_5Turbo = "gpt-3.5-turbo"
    /// Currently points to gpt-3.5-turbo-0613. Will point to gpt-3.5-turbo-1106 starting Dec 11, 2023.
    static let gpt3_5Turbo_16k = "gpt-3.5-turbo-16k"

    // Completions
    
    /// Very capable, faster and lower cost than Davinci.
    static let textCurie = "text-curie-001"
    /// Capable of straightforward tasks, very fast, and lower cost.
    static let textBabbage = "text-babbage-001"
    /// Capable of very simple tasks, usually the fastest model in the GPT-3 series, and lowest cost.
    static let textAda = "text-ada-001"
    
    // Images
    
    /// The latest DALL·E model released in Nov 2023.
    static let dalle3 = "dall-e-3"
    /// The previous DALL·E model released in Nov 2022. The 2nd iteration of DALL·E with more realistic, accurate, and 4x greater resolution images than the original model.
    static let dalle2 = "dall-e-2"
    
    // Edits
    
    static let textDavinci_001 = "text-davinci-001"
    static let codeDavinciEdit_001 = "code-davinci-edit-001"
    
    // TTS
    
    /// The latest text to speech model, optimized for speed.
    static let tts1 = "tts-1"
    /// The latest text to speech model, optimized for quality.
    static let tts1_hd = "tts-1-hd"
    
    // Transcriptions / Translations
    
    static let whisper_1 = "whisper-1"
    
    // Fine Tunes
    
    /// Most capable GPT-3 model. Can do any task the other models can do, often with higher quality.
    static let davinci = "davinci"
    /// Very capable, but faster and lower cost than Davinci.
    static let curie = "curie"
    /// Capable of straightforward tasks, very fast, and lower cost.
    static let babbage = "babbage"
    /// Capable of very simple tasks, usually the fastest model in the GPT-3 series, and lowest cost.
    static let ada = "ada"
    
    // Embeddings
    
    static let textEmbeddingAda = "text-embedding-ada-002"
    static let textSearchAda = "text-search-ada-doc-001"
    static let textSearchBabbageDoc = "text-search-babbage-doc-001"
    static let textSearchBabbageQuery001 = "text-search-babbage-query-001"
    
    // Moderations
    
    /// Almost as capable as the latest model, but slightly older.
    static let textModerationStable = "text-moderation-stable"
    /// Most capable moderation model. Accuracy will be slightly higher than the stable model.
    static let textModerationLatest = "text-moderation-latest"
}
