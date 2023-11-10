import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

protocol URLRequestBuildable {    
    associatedtype ResultType
    
    func build(token: String, organizationIdentifier: String?, timeoutInterval: TimeInterval) throws -> URLRequest
}
