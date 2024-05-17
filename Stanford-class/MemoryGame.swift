//
//  MemorizeGame.swift
//  Stanford-class
//
//  Created by Trần Ân on 15/5/24.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    
    private(set) var cards: Array<Card>
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent ) {
        cards = []
        for pairIndex in 0..<max(2,numberOfPairsOfCards) {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(id: "\(pairIndex+1)a", content: content))
            cards.append(Card(id: "\(pairIndex+1)b", content: content))
        }
    }
    
    var indexOfOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter { index in cards[index].isFaceup }.only }
        set { cards.indices.forEach{ cards[$0].isFaceup = (newValue == $0) } }
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }) {
            if !cards[chosenIndex].isFaceup && !cards[chosenIndex].isMatched {
                if let potentialMatch = indexOfOneAndOnlyFaceUpCard {
                    if cards[potentialMatch].content == cards[chosenIndex].content {
                        cards[potentialMatch].isMatched = true
                        cards[chosenIndex].isMatched = true
                    }
                } else {
                    indexOfOneAndOnlyFaceUpCard = chosenIndex
                }
                cards[chosenIndex].isFaceup = true
            }
            
        }
        
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    struct Card: Equatable, Identifiable, CustomDebugStringConvertible {
        var debugDescription: String {
            return "\(id): \(content) \(isFaceup ? "up" : "down") \(isMatched ? "match": "non")"
        }
        
        var id: String
    
        var isFaceup = false
        var isMatched = false
        var content: CardContent
    }
}

extension Array {
    var only: Element? {
        return count == 1 ? first : nil
    }
}
