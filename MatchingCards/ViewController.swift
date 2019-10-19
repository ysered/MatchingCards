
import UIKit

class ViewController: UIViewController, PlayingCardViewDelegate {
    
    private var game = Concentration()
    
    @IBOutlet var playingCardViews: [PlayingCardView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for cardView in playingCardViews {
            cardView.singleTapDelegate = self
        }
        initCards()
    }
    
    func onTap(playingCardView: PlayingCardView, index: Int) {
        guard playingCardViews.indices.contains(index) else {
            print("Index: \(index) out of cards bounds")
            return
        }
        
        let result = game.flipCard(at: index)
        switch (result) {
        case .flipCard(let index, let card): animateFlipOverCard(at: index, card: card)
        case .matchedCards(let cards): animateMatchedCards(cards)
        case .unMatchedCards(let cards): animateUnMatchedCards(cards)
        }
    }
    
    private func initCards() {
        for index in 0..<game.visibleCards.count {
            playingCardViews[index].show()
        }
    }
    
    private func animateFlipOverCard(at index: Int, card: Card) {
        playingCardViews[index].flipOver(card: game.visibleCards[index])
    }
    
    private func animateMatchedCards(_ cards: [Int: Card]) {
        for index in cards.keys {
            playingCardViews[index].hide()
        }
    }
    
    private func animateUnMatchedCards(_ cards: [Int: Card]) {
        for index in cards.keys {
            playingCardViews[index].flipBack()
        }
    }
}
