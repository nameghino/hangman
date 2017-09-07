//
//  executioner.swift
//  HangmanHelper
//
//  Created by Nico Ameghino on 9/7/17.
//

import Foundation

class Executioner {
    
    enum PlayerState {
        case alive, dead, won
    }

    private var shouldAskForWord: Bool
    private var word: String = ""
    private var guesses = Set<Character>()
    private var failedGuesses = Set<Character>()
    private var failedGuessesAllowed: Int
    
    private var dataInput: DataInput
    
    var state: PlayerState = .alive
    
    private var displayString: String {
        return ""
    }
    
    func update(with guess: Character) -> (PlayerState, String) {
        
        guesses.insert(guess)
        
        var m = ""
        var hits = 0
        failedGuesses = guesses
        
        for c in word {
            if guesses.contains(c) {
                m += "\(c)"
                failedGuesses.remove(c)
                hits += 1
            } else {
                m += "-"
            }
        }
        
        m += " (" + failedGuesses.sorted().map(String.init).joined(separator: ", ") + ")"
        
        if failedGuesses.count >= failedGuessesAllowed {
            return (.dead, m)
        }
        
        if hits == word.count {
            return (.won, word)
        }
        
        return (.alive, m)
        
    }
    
    init(input: DataInput = ConsoleDataInput(), word: String? = nil, failedGuessesAllowed: Int = 6) {
        self.dataInput = input
        self.shouldAskForWord = word == nil
        if let w = word { self.word = w }
        self.failedGuessesAllowed = failedGuessesAllowed
    }
    
    func promptAndGetCharacter() -> Character {
        print("#", separator: "", terminator: "> ")
        guard let l = dataInput.read()?.uppercased(), let c = l.first else { fatalError() }
        return c
    }
    
    func promptAndGetString() -> String {
        print("pick your word", separator: "", terminator: "> ")
        guard let l = dataInput.read()?.uppercased() else { fatalError() }
        return l
    }

    func promptAndGetCharacter(callback: @escaping (Character) -> Void) {
        print("#", separator: "", terminator: "> ")
        guard let l = dataInput.read()?.uppercased(), let c = l.first else { fatalError() }
        callback(c)
    }
    
    func promptAndGetString(callback: @escaping (String) -> Void) {
        print("pick your word", separator: "", terminator: "> ")
        guard let l = dataInput.read()?.uppercased() else { fatalError() }
        callback(l)
    }

    
    
    func play() -> OSStatus {
        if shouldAskForWord {
            self.word = promptAndGetString()
            shouldAskForWord = false
        }
        
        while true {
            let c = promptAndGetCharacter()
            let (state, message) = update(with: c)
            
            print(message)
            
            switch state {
            case .alive:
                break
            case .dead:
                print("Player died.")
                return 1
            case .won:
                print("Player won.")
                return 0
            }
        }
    }
}
