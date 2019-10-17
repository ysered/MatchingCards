
import UIKit

class ViewController: UIViewController, PlayingCardViewDelegate {

    @IBOutlet var playingCardViews: [PlayingCardView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for cardView in playingCardViews {
            cardView.singleTapDelegate = self
        }
    }
    
    func onTap(view: PlayingCardView, index: Int) {
        print("User tapped on view with index: \(index)")
        view.flipOver()
    }
}
