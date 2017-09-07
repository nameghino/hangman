import Foundation

extension String {
    public func has(_ character: Character, at index: Int) -> Bool {
        let i = self.index(startIndex, offsetBy: index)
        return self[i] == character
    }
    
    func matches(other: String) -> Bool {
    
        let wildcards: [Character] = ["*", "-", "."]
        
        guard self.count == other.count else { return false }
        for i in 0..<self.count {
            
            let ii = self.index(startIndex, offsetBy: i)
            guard !wildcards.contains(self[ii]) else { continue }
            
            let ij = other.index(startIndex, offsetBy: i)
            if self[ii] != other[ij] { return false }
        }
        return true
    }
}

extension Sequence where Element: Equatable & Hashable {
    public func histogram() -> [Element : Int] {
        var r: [Element : Int] = [:]
        for x in self {
            r[x, default: 0] += 1
        }
        return r
    }
}
