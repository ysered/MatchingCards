
import Foundation

struct Card : Equatable, Hashable, CustomStringConvertible {
    
    var description: String {
        return "Card(rank=\(rank.rawValue), isFacedUp=\(isFaceUp), isMatched=\(isMatched))"
    }
    
    var rank: Rank
    var isFaceUp = false
    var isMatched = false
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.rank == rhs.rank
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(rank)
        hasher.combine(isFaceUp)
        hasher.combine(isMatched)
    }
}

enum Rank: Int {
    case black
    case red
    case blue
    
    static var all: [Rank] {
        return [.black, .red, .blue]
    }
    
    static var count: Int {
        return all.count
    }
}
