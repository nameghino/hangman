
// -- this goes into guesser.swift, but xcode is not cooperating
import Foundation

public class HangmanGuesser {
    lazy var dictionary: [String] = {
        
        guard let d = NSKeyedUnarchiver.unarchiveObject(withFile: dictionaryURL.path) as? [String] else { fatalError("unable to decode plist") }
        //let d = try! String(contentsOf: self.dictionaryURL).split(separator: "\n").map { "\($0)" }
        dictionaryIsLoaded = true
        return d
    }()
    
    private var dictionaryIsLoaded = false
    private let dictionaryURL: URL
    
    // uses the wordlist from the bundle
    public convenience init() {
        let processedFilename = "wordlist-es-processed"
        
        
        
        guard let targetURL = Bundle.main.resourceURL?.appendingPathComponent("test.plist") else {
            fatalError("no resource found")
        }
 
        self.init(dictionary: targetURL)
    }
    
    public required init(dictionary url: URL) {
        dictionaryURL = url
    }
    
    public func process(guess: String) -> [String] {
        print("working on \(dictionary.count) words")
        
        let valid = dictionary.filter { $0.count == guess.count }
        print("filtered to \(valid.count) words")
        
        let h = valid.joined().histogram()
        let th = transposeHistogram(h)
        var result = [String]()
        for k in th.keys.sorted().reversed() {
            print("rank: \(k): \(th[k]!)")
            result.append("\(th[k]!)")
        }
        return result
    }
    
    private func promptAndRead(prompt: String = "#") -> String? {
        print(prompt, separator: "", terminator: "> ")
        guard let input = readLine() else {
            print("No input")
            return nil
        }
        
        return input
    }
    
    public func play() {
        var lastInput: String = "#"
        var current = dictionary
        var alreadyFilteredLength = false
        
        while true {
            guard let input = promptAndRead(prompt: lastInput) else { return }
            lastInput = input
            
            if !alreadyFilteredLength {
                current = current.filter { $0.count == input.count }
                print("removing words that don't match length")
                alreadyFilteredLength = true
            }
            
            current = current.filter { input.matches(other: $0) }
            print("narrowed it down to \(current.count) words")
            let h = transposeHistogram(current.reduce("", +).histogram())
            let m = "try guessing: " + h.keys.sorted().reversed()[0..<10].flatMap { "\(h[$0]!)" }.joined(separator: ", ")
            print(m)
        }
        
    }
}

extension HangmanGuesser: CustomStringConvertible {
    public var description: String {
        return "<HangmanGuesser dictionary=\"\(dictionaryURL.absoluteString)\" loaded=\(dictionaryIsLoaded)/>"
    }
}
// -- end of guesser.swift
