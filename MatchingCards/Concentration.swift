
import Foundation

struct Concentration {
    
    static let dealMoreCardCount = 3
    static let startCardCount = 12
    static let visibleRoomCardCount = startCardCount * 2
    static let cardDeckCount = 81
    static let combinationOfCards = Concentration.cardDeckCount / Rank.count
    
    private var cardDeck = [Card]()
    var visibleCards = [Card]()
    private var facedUpCardIndicies = [Int]()
    
    var hasRoomForMoreCards: Bool {
        let freeSpace = Concentration.visibleRoomCardCount - visibleCards.count + visibleCards.filter { $0.isMatched }.count
        return freeSpace >= Concentration.dealMoreCardCount
            && !cardDeck.isEmpty
            && cardDeck.count >= Concentration.dealMoreCardCount
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
    
    /// Add more cards to game and returns indicies where new cards added.
    mutating func dealMoreCards() -> [Int]? {
        if hasRoomForMoreCards, let indices = findIndiciesForMoreCards() {
            for index in indices {
                if !cardDeck.isEmpty {
                    let card = cardDeck.removeFirst()
                    if visibleCards.indices.contains(index) {
                        visibleCards[index] = card
                    } else {
                        visibleCards.insert(card, at: index)
                    }
                    print("Inserted card from deck: \(card) at index: \(index)")
                } else {
                    break
                }
            }
            return indices
        }
        return nil
    }
    
    mutating func flipCard(at index: Int) -> FlipCardResult {
        // flip back if alread faced up
        if visibleCards[index].isFaceUp {
            visibleCards[index].isFaceUp = false
            facedUpCardIndicies.removeAll {(value: Int) in value == index }
            return .flipBack(index)
        }
        
        var result: FlipCardResult
        // face up third card and check if they all match
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
                visibleCards[first].isMatched = false
                visibleCards[second].isMatched = false
                visibleCards[index].isMatched = false
                visibleCards[first].isFaceUp = false
                visibleCards[second].isFaceUp = false
                visibleCards[index].isFaceUp = false
            }
            facedUpCardIndicies = []
        } else { // face up single card
            visibleCards[index].isFaceUp = true
            result = .flipCard(index)
            facedUpCardIndicies.append(index)
        }
        return result
    }
    
    private func findIndiciesForMoreCards() -> [Int]? {
        guard hasRoomForMoreCards else {
            print("No indicies for more cards!")
            return nil
        }
        let matchedCardIndicies = getMatchedCardIndicies()
        if !matchedCardIndicies.isEmpty {
            print("Found indicies for more cards: \(matchedCardIndicies)")
            return matchedCardIndicies
        }
        let visibleCardsCount = visibleCards.count
        if Concentration.cardDeckCount - visibleCardsCount >= Concentration.dealMoreCardCount {
            print("Found indicies for more cards: [\(visibleCardsCount), \(visibleCardsCount + 1), \(visibleCardsCount + 2)]")
            return [visibleCardsCount, visibleCardsCount + 1, visibleCardsCount + 2]
        }
        print("No indicies for more cards!")
        return nil
    }
    
    private func getMatchedCardIndicies(upTo count: Int = 3) -> [Int] {
        var matchedCardIndicies = [Int]()
        for (index, card) in visibleCards.enumerated() {
            if card.isMatched {
                matchedCardIndicies.append(index)
            }
            if matchedCardIndicies.count == count {
                break
            }
        }
        return matchedCardIndicies
    }
}

enum FlipCardResult {
    case flipCard(Int)
    case flipBack(Int)
    case matchedCards(first: Int, second: Int, third: Int)
    case unMatchedCards(first: Int, second: Int, third: Int)
}
