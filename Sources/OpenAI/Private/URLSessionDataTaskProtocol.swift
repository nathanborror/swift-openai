import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

protocol URLSessionDataTaskProtocol {    
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}
