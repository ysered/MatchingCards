
import UIKit

class ViewController: UIViewController, PlayingCardViewDelegate {
    
    private var game = Concentration()
    private var score: Int = 0 {
        didSet(newValue) {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    @IBOutlet var playingCardViews: [PlayingCardView]!
    @IBOutlet weak var dealMoreCardsButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for cardView in playingCardViews {
            cardView.singleTapDelegate = self
        }
        initCards()
        updateDealMoreCardsButton()
    }
    
    func onTap(playingCardView: PlayingCardView, index: Int) {
        guard playingCardViews.indices.contains(index) else {
            print("Index: \(index) out of cards bounds")
            return
        }
        
        let result = game.flipCard(at: index)
        switch (result) {
        case .flipCard(let index): animateFlipOverCard(at: index)
        case .flipBack(let index): animateFlipBackCard(at: index)
        case .matchedCards(let first, let second, let third):
            score = score + 2
            animateMatchedCards(firstIndex: first, secondIndex: second, thirdIndex: third)
        case .unMatchedCards(let first, let second, let third):
            score = score > 1 ? score - 1 : 0
            animateUnMatchedCards(firstIndex: first, secondIndex: second, thirdIndex: third)
        }
    }
    
    @IBAction func deal3MoreCards(_ sender: UIButton) {
        if let newCardIndicies = game.dealMoreCards() {
            for newIndex in newCardIndicies {
                playingCardViews[newIndex].animateInsertion(for: game.visibleCards[newIndex])
            }
            updateDealMoreCardsButton()
        }
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        game = Concentration()
        initCards()
        updateDealMoreCardsButton()
        score = 0
    }
    
    // MARK: Private Functions
    
    private func initGame() {
        game = Concentration()
        initCards()
        updateDealMoreCardsButton()
    }
    
    private func initCards() {
        for index in 0..<game.visibleCards.count {
            playingCardViews[index].animateInsertion(for: game.visibleCards[index])
        }
        for index in game.visibleCards.count..<playingCardViews.count {
            playingCardViews[index].hide()
        }
    }
    
    private func animateFlipOverCard(at index: Int) {
        playingCardViews[index].flipOver(card: game.visibleCards[index])
    }
    
    private func animateFlipBackCard(at index: Int) {
        playingCardViews[index].flipBack()
    }
    
    private func animateMatchedCards(firstIndex: Int, secondIndex: Int, thirdIndex: Int) {
        lockAllCards()
        playingCardViews[thirdIndex].flipOver(card: game.visibleCards[thirdIndex])
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.playingCardViews[firstIndex].hide()
            self.playingCardViews[secondIndex].hide()
            self.playingCardViews[thirdIndex].hide()
            self.unlockAllCards()
            self.updateDealMoreCardsButton()
        }
    }
    
    private func animateUnMatchedCards(firstIndex: Int, secondIndex: Int, thirdIndex: Int) {
        lockAllCards()
        playingCardViews[thirdIndex].flipOver(card: game.visibleCards[thirdIndex])
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.playingCardViews[firstIndex].flipBack()
            self.playingCardViews[secondIndex].flipBack()
            self.playingCardViews[thirdIndex].flipBack()
            self.unlockAllCards()
        }
    }
    
    private func lockAllCards() {
        for cardView in playingCardViews {
            cardView.isUserInteractionEnabled = false
        }
    }
    
    private func unlockAllCards() {
        for cardView in playingCardViews {
            cardView.isUserInteractionEnabled = true
        }
    }
    
    private func updateDealMoreCardsButton() {
        dealMoreCardsButton.isEnabled = game.hasRoomForMoreCards
    }
}
