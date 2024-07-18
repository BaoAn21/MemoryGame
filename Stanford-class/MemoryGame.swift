//
//  MemorizeGame.swift
//  Stanford-class
//
//  Created by Trần Ân on 15/5/24.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    
    private(set) var cards: Array<Card>
    private(set) var score = 0
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent ) {
        cards = []
        for pairIndex in 0..<max(2,numberOfPairsOfCards) {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(id: UUID().uuidString, content: content))
            cards.append(Card(id: UUID().uuidString, content: content))
        }
    }
    
    var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            cards.indices.filter { index in cards[index].isFaceup }.only
        }
        set {
            cards.indices.forEach{ cards[$0].isFaceup = (newValue == $0) }
        }
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }) {
            if !cards[chosenIndex].isFaceup && !cards[chosenIndex].isMatched {
                if let potentialMatch = indexOfOneAndOnlyFaceUpCard { // If there is already a face up card
                    // Mark two card as matched if their content is match
                    if cards[potentialMatch].content == cards[chosenIndex].content {
                        cards[potentialMatch].isMatched = true
                        cards[chosenIndex].isMatched = true
                        score += 2 + cards[chosenIndex].bonus + cards[potentialMatch].bonus
                    } else {
                        if cards[chosenIndex].hasBeenSeen {
                            score -= 1
                        }
                        
                        if cards[potentialMatch].hasBeenSeen {
                            score -= 1
                        }
                    }
                    cards[chosenIndex].isFaceup = true
                } else { // If no card is already face up, mark this card as only card face up
                    
                    indexOfOneAndOnlyFaceUpCard = chosenIndex
                }
            }
        }
    }
    
    // Handle score
    
    
    mutating func shuffle() {
        cards.shuffle()
    }

    
    // Card Struct
    struct Card: Equatable, Identifiable, CustomDebugStringConvertible {
        var debugDescription: String {
            return "\(id): \(content) \(isFaceup ? "up" : "down") \(isMatched ? "match": "non")"
        }
        
        var id = UUID().uuidString
    
        var isFaceup = false {
            didSet {
                if isFaceup {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
                if oldValue && !isFaceup {
                    hasBeenSeen = true
                }
            }
        }
        var isMatched = false {
            didSet {
                if isMatched {
                    stopUsingBonusTime()
                }
            }
        }
        var hasBeenSeen = false
        var content: CardContent
        
        // MARK: - Bonus Time
        
        // call this when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isFaceup && !isMatched && bonusPercentRemaining > 0, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        // call this when the card goes back face down or gets matched
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            lastFaceUpDate = nil
        }
        
        // the bonus earned so far (one point for every second of the bonusTimeLimit that was not used)
        // this gets smaller and smaller the longer the card remains face up without being matched
        var bonus: Int {
            Int(bonusTimeLimit * bonusPercentRemaining)
        }
        
        // percentage of the bonus time remaining
        var bonusPercentRemaining: Double {
            bonusTimeLimit > 0 ? max(0, bonusTimeLimit - faceUpTime)/bonusTimeLimit : 0
        }
        
        // how long this card has ever been face up and unmatched during its lifetime
        // basically, pastFaceUpTime + time since lastFaceUpDate
        var faceUpTime: TimeInterval {
            if let lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        // can be zero which would mean "no bonus available" for matching this card quickly
        var bonusTimeLimit: TimeInterval = 6
        
        // the last time this card was turned face up
        var lastFaceUpDate: Date?
        
        // the accumulated time this card was face up in the past
        // (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0
    }
}

extension Array {
    var only: Element? {
        if (count == 1 ) {
            return first
        } else {
            return nil
        }
    }
}
