
import Foundation

struct Concentration {
    
    static let dealMoreCardCount = 3
    static let startCardCount = 12
    static let visibleRoomCardCount = startCardCount * 2
    static let cardDeckCount = 81
    static let combinationOfCards = Concentration.cardDeckCount / Rank.count
    
    var visibleCardsCount: Int {
        visibleCards.count
    }
    
    private var cardDeck = [Card]()
    private(set) var visibleCards = [Card]()
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
        newGame()
    }
    
    mutating func newGame() {
        cardDeck = []
        visibleCards = []
       
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
    mutating func dealMoreCards(onResult: ([(Int, Card)]) -> Void) {
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
            let indiciesAndCards = indices.map { ($0, visibleCards[$0]) }
            onResult(indiciesAndCards)
        }
        return onResult([])
    }
    
    mutating func flipCard(at index: Int, onResult: (FlipCardResult) -> Void) {
        // flip back if alread faced up
        if visibleCards[index].isFaceUp {
            visibleCards[index].isFaceUp = false
            facedUpCardIndicies.removeAll {(value: Int) in value == index }
            onResult(.flipBack(index))
            return
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
                result = .matchedCards(firstIndex: first, secondIndex: second, thirdIndex: index, lastCard: visibleCards[index])
                visibleCards[first].isMatched = true
                visibleCards[second].isMatched = true
                visibleCards[index].isMatched = true
            } else {
                result = .unMatchedCards(firstIndex: first, secondIndex: second, thirdIndex: index, lastCard: visibleCards[index])
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
            result = .flipCard(index, visibleCards[index])
            facedUpCardIndicies.append(index)
        }
        onResult(result)
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
    case flipCard(Int, Card)
    case flipBack(Int)
    case matchedCards(firstIndex: Int, secondIndex: Int, thirdIndex: Int, lastCard: Card)
    case unMatchedCards(firstIndex: Int, secondIndex: Int, thirdIndex: Int, lastCard: Card)
}
