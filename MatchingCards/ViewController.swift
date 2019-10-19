
import UIKit

class ViewController: UIViewController, PlayingCardViewDelegate {

    private var game = Concentration()
    
    @IBOutlet var playingCardViews: [PlayingCardView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for cardView in playingCardViews {
            cardView.singleTapDelegate = self
        }
        updateGameScene()
    }
    
    func onTap(playingCardView: PlayingCardView, index: Int) {
        guard playingCardViews.indices.contains(index) else {
            print("Index: \(index) out of cards bounds")
            return
        }
        playingCardView.flipOver(card: game.visibleCards[index])
    }
    
    private func updateGameScene() {
        for index in 0..<game.visibleCards.count {
            playingCardViews[index].show()
        }
    }
}
