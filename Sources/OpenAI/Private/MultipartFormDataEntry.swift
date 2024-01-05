import Foundation

enum MultipartFormDataEntry {
    
    case file(paramName: String, fileData: Data, contentType: String)
    case string(paramName: String, value: Any?)
}
