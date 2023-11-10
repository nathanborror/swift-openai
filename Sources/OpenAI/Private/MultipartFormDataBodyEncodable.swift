import Foundation

protocol MultipartFormDataBodyEncodable {
    func encode(boundary: String) -> Data
}
