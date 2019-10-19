
import Foundation
import UIKit


public extension Array {
    var second: Element? {
        return count >= 1 ? self[1] : nil
    }
    var third: Element? {
        return count >= 2 ? self[2] : nil
    }
}

public extension UIFont {
    static func scaledFont(forTextStyle: UIFont.TextStyle, fontSize: CGFloat) -> UIFont {
        let font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
    }
}
