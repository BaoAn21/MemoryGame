//
//  EmojiMemoryGame.swift
//  Stanford-class
//
//  Created by Trần Ân on 15/5/24.
//

import SwiftUI



class EmojiMemoryGame: ObservableObject {
    @Published private var gameModel: MemoryGame<String>
    
    var gameTheme: Theme = themes.randomElement()!
    
    init() {
        gameTheme.emojis.shuffle()
        gameModel = EmojiMemoryGame.createMemoryGame(gameTheme: gameTheme)
        gameModel.shuffle()
    }
    
    private static func createMemoryGame(gameTheme: Theme) -> MemoryGame<String> {
        return MemoryGame(numberOfPairsOfCards: 3) { index in
            if gameTheme.emojis.indices.contains(index) {
                return gameTheme.emojis[index]
            } else {
                return "⁉️"
            }
        }
    }
    
    var score: Int {
        gameModel.score
    }
    
    
    var cards: Array<MemoryGame<String>.Card> {
        return gameModel.cards
    }
    
    // MARK: -- Intents
    func shuffle() {
        gameModel.shuffle()
    }
    
    func choose(_ card: MemoryGame<String>.Card) {
        gameModel.choose(card)
    }
    
    func newGame() {
        var newGameTheme = themes.randomElement()!
        newGameTheme.emojis.shuffle()
        gameModel = EmojiMemoryGame.createMemoryGame(gameTheme: newGameTheme)
        gameModel.shuffle()
    }
}
