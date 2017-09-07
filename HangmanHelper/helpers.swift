import Foundation

public func transposeHistogram<T>(_ h: [T : Int]) -> [Int : [T]] {
    var r: [Int : [T]] = [:]
    for (k, v) in h {
        r[v, default: []].append(k)
    }
    return r
}

protocol DataInput {
    func read() -> String?
    func read(callback: @escaping (String?) -> Void)
}

class ConsoleDataInput: DataInput {
    func read() -> String? {
        return readLine()
    }
    
    func read(callback: @escaping (String?) -> Void) {
        let s = read()
        callback(s)
    }
}

