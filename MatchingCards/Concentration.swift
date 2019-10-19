
import Foundation

struct Concentration {
    
    static let dealMoreCardCount = 3
    static let startCardCount = 12
    static let visibleRoomCardCount = startCardCount * 2
    static let cardDeckCount = startCardCount * Rank.count
    static let combinationOfCards = Concentration.cardDeckCount / Rank.count
    
    private var cardDeck = [Card]()
    var visibleCards = [Card]()
    private var facedUpCards = Set<Card>()
    
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
}
