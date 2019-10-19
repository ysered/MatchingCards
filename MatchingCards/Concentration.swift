
import Foundation

struct Concentration {
    
    static let dealMoreCardCount = 3
    static let startCardCount = 12
    static let visibleRoomCardCount = startCardCount * 2
    static let cardDeckCount = startCardCount * Rank.count
    static let combinationOfCards = Concentration.cardDeckCount / Rank.count
    
    private var cardDeck = [Card]()
    var visibleCards = [Card]()
    private var facedUpCardIndicies = [Int]()
    
    var hasRoomForMoreCards: Bool {
        return Concentration.visibleRoomCardCount - visibleCards.count >= Concentration.dealMoreCardCount
    }
         
    init() {
        cardDeck.reserveCapacity(Concentration.cardDeckCount)
        visibleCards.reserveCapacity(Concentration.visibleRoomCardCount)
        
        for _ in 0...Concentration.combinationOfCards {
            for cardSymbol in Rank.all {
                cardDeck.append(Card(rank: cardSymbol))
            }
        }
        cardDeck.shuffle()
        for _ in 0..<Concentration.startCardCount {
            visibleCards.append(cardDeck.removeFirst())
        }
    }
    
    func dealMoreCards() {
        if hasRoomForMoreCards {
            
        }
    }
    
    mutating func flipCard(at index: Int) -> FlipCardResult {
        var result: FlipCardResult
        if facedUpCardIndicies.count == 2
            && visibleCards.indices.contains(index),
            let first = facedUpCardIndicies.first,
            let second = facedUpCardIndicies.second {
            
            let firstCard = visibleCards[first]
            let secondCard = visibleCards[second]
            let thirdCard = visibleCards[index]
            
            if firstCard == secondCard && secondCard == thirdCard {
                result = .matchedCards(first: first, second: second, third: index)
                visibleCards[first].isMatched = true
                visibleCards[second].isMatched = true
                visibleCards[index].isMatched = true
            } else {
                result = .unMatchedCards(first: first, second: second, third: index)
            }
            facedUpCardIndicies = []
        } else {
            result = .flipCard(index, visibleCards[index])
            facedUpCardIndicies.append(index)
        }
        return result
    }
}

enum FlipCardResult {
    case flipCard(Int, Card)
    case matchedCards(first: Int, second: Int, third: Int)
    case unMatchedCards(first: Int, second: Int, third: Int)
}
