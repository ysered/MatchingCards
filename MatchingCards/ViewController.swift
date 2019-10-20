
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
        
        game.flipCard(at: index, onResult: { (result: FlipCardResult) in
            switch (result) {
            case .flipCard(let index, let card):
                animateFlipOverCard(at: index, card: card)
            
            case .flipBack(let index):
                animateFlipBackCard(at: index)
                
            case .matchedCards(let firstIndex, let secondIndex, let thirdIndex, let lastCard):
                score = self.score + 2
                animateMatchedCards(firstIndex: firstIndex, secondIndex: secondIndex, thirdIndex: thirdIndex, lastCard: lastCard)
            
            case .unMatchedCards(let firstIndex, let secondIndex, let thirdIndex, let lastCard):
                score = score > 1 ? score - 1 : 0
                animateUnMatchedCards(firstIndex: firstIndex, secondIndex: secondIndex, thirdIndex: thirdIndex, lastCard: lastCard)
            }
        })
    }
    
    @IBAction func deal3MoreCards(_ sender: UIButton) {
        game.dealMoreCards(onResult: { (newCards: [(index: Int, card: Card)]) in
            for (index, card) in newCards {
                playingCardViews[index].animateInsertion(for: card)
            }
        })
        updateDealMoreCardsButton()
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
        for index in 0..<game.visibleCardsCount {
            playingCardViews[index].animateInsertion(for: game.visibleCards[index])
        }
        for index in game.visibleCardsCount..<playingCardViews.count {
            playingCardViews[index].hide()
        }
    }
    
    private func animateFlipOverCard(at index: Int, card: Card) {
        playingCardViews[index].flipOver(card: card)
    }
    
    private func animateFlipBackCard(at index: Int) {
        playingCardViews[index].flipBack()
    }
    
    private func animateMatchedCards(firstIndex: Int, secondIndex: Int, thirdIndex: Int, lastCard: Card) {
        lockAllCards()
        playingCardViews[thirdIndex].flipOver(card: lastCard)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.playingCardViews[firstIndex].hide()
            self.playingCardViews[secondIndex].hide()
            self.playingCardViews[thirdIndex].hide()
            self.unlockAllCards()
            self.updateDealMoreCardsButton()
        }
    }
    
    private func animateUnMatchedCards(firstIndex: Int, secondIndex: Int, thirdIndex: Int, lastCard: Card) {
        lockAllCards()
        playingCardViews[thirdIndex].flipOver(card: lastCard)
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
