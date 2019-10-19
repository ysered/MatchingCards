import UIKit

class PlayingCardView: UIView {
    
    // MARK: Public Properties
    
    var isFaceUp: Bool = false
    
    var faceUpColor: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    var faceDownColor: UIColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
    var invisibleColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
    
    var cornerRadius: CGFloat = 10.0
    var fontSize: CGFloat = 50.0
    
    var isVisible = false { didSet { refresh() } }
    
    weak var singleTapDelegate: PlayingCardViewDelegate? = nil
    
    // MARK: Private Properties
    
    private var rankSymbol: Character = "?"
    private lazy var symbolLabel: UILabel = createCenterLabel()
    
    private var stringToDraw: NSAttributedString {
        return centeredAttributedString(String(rankSymbol), fontSize: fontSize)
    }

    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
        
    // MARK: Overrides
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if sender.view === self && isVisible {
            singleTapDelegate?.onTap(playingCardView: self, index: tag)
        }
    }
    
    override func draw(_ rect: CGRect) {
        if !isVisible {
            invisibleColor.setFill()
            let rect = UIBezierPath.init(rect: bounds)
            rect.fill()
            return
        }
        
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
    
    // MARK: Public API
    
    func flipOver(card: Card) {
        if (isFaceUp) { // do now flip over card which is faced up
            return
        }
        
        rankSymbol = getCharacterForCard(card: card)
        isFaceUp.toggle()
        refresh()
    }
    
    // TODO: merge with filpCard? Think about better name.
    func flipBack() {
        isFaceUp.toggle()
        refresh()
    }
    
    func show() {
        isVisible = true
    }
    
    func hide() {
        self.rankSymbol = " "
        isVisible = false
    }
    
    // MARK: Private functions
    
    private func setup() {
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        addGestureRecognizer(tap)
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
    
    private func createCenterLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        addSubview(label)
        return label
    }
    
    private func prepareSymbolLabel() {
        if isHidden {
            return
        }
        symbolLabel.attributedText = centeredAttributedString(String(rankSymbol), fontSize: fontSize)
        symbolLabel.frame.size = CGSize.zero
        symbolLabel.sizeToFit()
        symbolLabel.frame.origin = CGPoint(x: bounds.midX - symbolLabel.bounds.width / 2, y: bounds.height / 2 - symbolLabel.bounds.height / 2)
        symbolLabel.isHidden = !isFaceUp
    }
    
    private func getCharacterForCard(card: Card) -> Character {
        switch card.rank {
        case .black: return "⚫️"
        case .blue: return "🔵"
        case .red: return "🔴"
        }
    }
}

// MARK: Delegate

protocol PlayingCardViewDelegate : class {
    func onTap(playingCardView: PlayingCardView, index: Int)
}

// MARK: Extensions

extension UIFont {
    static func scaledFont(forTextStyle: UIFont.TextStyle, fontSize: CGFloat) -> UIFont {
        let font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
    }
}
