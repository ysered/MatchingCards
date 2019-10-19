
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
        case .matchedCards(let first, let second, let third):
            animateMatchedCards(firstIndex: first, secondIndex: second, thirdIndex: third)
        case .unMatchedCards(let first, let second, let third):
            animateUnMatchedCards(firstIndex: first, secondIndex: second, thirdIndex: third)
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
    
    private func animateMatchedCards(firstIndex: Int, secondIndex: Int, thirdIndex: Int) {
        lockOtherCards(exceptOf: firstIndex, secondIndex, thirdIndex)
        playingCardViews[thirdIndex].flipOver(card: game.visibleCards[thirdIndex])
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.playingCardViews[firstIndex].hide()
            self.playingCardViews[secondIndex].hide()
            self.playingCardViews[thirdIndex].hide()
            self.unlockOtherCards(exceptOf: firstIndex, secondIndex, thirdIndex)
        }
    }
    
    private func animateUnMatchedCards(firstIndex: Int, secondIndex: Int, thirdIndex: Int) {
        lockOtherCards(exceptOf: firstIndex, secondIndex, thirdIndex)
        playingCardViews[thirdIndex].flipOver(card: game.visibleCards[thirdIndex])
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.playingCardViews[firstIndex].flipBack()
            self.playingCardViews[secondIndex].flipBack()
            self.playingCardViews[thirdIndex].flipBack()
            self.unlockOtherCards(exceptOf: firstIndex, secondIndex, thirdIndex)
        }
    }
    
    private func lockOtherCards(exceptOf indices: Int...) {
        for (index, cardView) in playingCardViews.enumerated() {
            if !indices.contains(index) {
                cardView.isUserInteractionEnabled = false
            }
        }
    }
    
    private func unlockOtherCards(exceptOf indices: Int...) {
        for (index, cardView) in playingCardViews.enumerated() {
            if !indices.contains(index) {
                cardView.isUserInteractionEnabled = true
            }
        }
    }
}
