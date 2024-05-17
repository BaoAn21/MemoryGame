//
//  EmojiMemoryGame.swift
//  Stanford-class
//
//  Created by Trần Ân on 15/5/24.
//

import SwiftUI



class EmojiMemoryGame: ObservableObject {
    private static let emojis = ["🎃","👻","🧛🏿‍♂️","🧟","🧞‍♀️","🍭"]
    
    private static func createMemoryGame() -> MemoryGame<String> {
        return MemoryGame(numberOfPairsOfCards: 10) { index in
            if emojis.indices.contains(index) {
                return emojis[index]
            } else {
                return "⁉️"
            }
        }
    }
    
    @Published private var model: MemoryGame = createMemoryGame()
    
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
    // MARK: -- Intents
    func shuffle() {
        model.shuffle()
    }
    
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
    
    func newGame() {
        
    }
}
