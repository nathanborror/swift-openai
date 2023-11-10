import Foundation

enum MultipartFormDataEntry {
    
    case file(paramName: String, fileName: String, fileData: Data, contentType: String),
         string(paramName: String, value: Any?)
}
