import Foundation

public struct Vector {
    
    /// Returns the similarity between two vectors
    public static func cosineSimilarity(a: [Double], b: [Double]) -> Double {
        dot(a, b) / (mag(a) * mag(b))
    }

    /// Returns the difference between two vectors. Cosine distance is defined as `1 - cosineSimilarity(a, b)`
    public func cosineDifference(a: [Double], b: [Double]) -> Double {
        1 - Self.cosineSimilarity(a: a, b: b)
    }
}
 
private extension Vector {

    static func round(_ input: Double, to places: Int = 1) -> Double {
        let divisor = pow(10.0, Double(places))
        return (input * divisor).rounded() / divisor
    }

    static func dot(_ a: [Double], _ b: [Double]) -> Double {
        assert(a.count == b.count, "Vectors must have the same dimension")
        return zip(a, b)
            .map { $0 * $1 }
            .reduce(0, +)
    }

    static func mag(_ vector: [Double]) -> Double {
        sqrt(dot(vector, vector))
    }
}
