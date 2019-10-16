import UIKit

class PlayingCardView: UIView {

    var isFaceUp: Bool = false
    var faceUpColor: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    var faceDownColor: UIColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
    var cornerRadius: CGFloat = 10.0
    var fontSize: CGFloat = 50.0
    var symbol: Character = "?"
    
    private lazy var symbolLabel: UILabel = createCenterLabel()
    
    private var stringToDraw: NSAttributedString {
        return centeredAttributedString(String(symbol), fontSize: fontSize)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isFaceUp {
            return
        }
        if touches.count == 1 && event?.type == .touches {
            toggle()
        }
    }
    
    override func draw(_ rect: CGRect) {
        if isFaceUp {
            faceUpColor.setFill()
        } else {
            faceDownColor.setFill()
        }
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.fill()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        prepareSymbolLabel()
    }
    
    func toggle() {
        isFaceUp = !isFaceUp
        refresh()
    }
    
    private func refresh() {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    private func centeredAttributedString(_ string: String, fontSize: CGFloat) -> NSAttributedString {
        let scaledFont = UIFont.scaledFont(forTextStyle: .body, fontSize: fontSize)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return NSAttributedString(string: string, attributes: [.paragraphStyle: paragraphStyle, .font: scaledFont])
    }
    
    func createCenterLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        addSubview(label)
        return label
    }
    
    func prepareSymbolLabel() {
        symbolLabel.attributedText = centeredAttributedString(String(symbol), fontSize: fontSize)
        symbolLabel.frame.size = CGSize.zero
        symbolLabel.sizeToFit()
        symbolLabel.frame.origin = CGPoint(x: bounds.midX - symbolLabel.bounds.width / 2, y: bounds.height / 2 - symbolLabel.bounds.height / 2)
        symbolLabel.isHidden = !isFaceUp
    }
}

extension UIFont {
    static func scaledFont(forTextStyle: UIFont.TextStyle, fontSize: CGFloat) -> UIFont {
        let font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
    }
}
