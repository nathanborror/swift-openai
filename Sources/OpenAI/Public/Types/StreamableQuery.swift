import Foundation

protocol Streamable {
    var stream: Bool { get set }
    
    func makeStreamable() -> Self
}

extension Streamable {
    
    func makeStreamable() -> Self {
        var copy = self
        copy.stream = true
        return copy
    }
}
 
