
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
        for _ in 0...Concentration.startCardCount {
            visibleCards.append(cardDeck.removeFirst())
        }
    }
    
    func dealMoreCards() {
        if hasRoomForMoreCards {
            
        }
    }
    
    mutating func flipCard(at index: Int) -> FlipCardResult {
        var result: FlipCardResult
        if facedUpCardIndicies.count == 3,
            let first = facedUpCardIndicies.first,
            let second = facedUpCardIndicies.second,
            let third = facedUpCardIndicies.third {
            
            let firstCard = visibleCards[first]
            let secondCard = visibleCards[second]
            let thirdCard = visibleCards[third]
            
            if firstCard == secondCard && secondCard == thirdCard {
                result = .matchedCards(matchedCards: [
                                        first: firstCard,
                                        second: secondCard,
                                        third: thirdCard])
                visibleCards[first].isMatched = true
                visibleCards[second].isMatched = true
                visibleCards[third].isMatched = true
            } else {
                result = .unMatchedCards(unmatchedCards: [
                                            first: firstCard,
                                            second: secondCard,
                                            third: thirdCard])
            }
            facedUpCardIndicies = []
        } else {
            result = .flipCard(index, visibleCards[index])
            facedUpCardIndicies.append(index)
        }
        return result
    }
}

extension Array {
    var second: Element? {
        return count >= 1 ? self[1] : nil
    }
    var third: Element? {
        return count >= 2 ? self[2] : nil
    }
}

enum FlipCardResult {
    case flipCard(Int, Card)
    case matchedCards(matchedCards: [Int: Card])
    case unMatchedCards(unmatchedCards: [Int: Card])
}
