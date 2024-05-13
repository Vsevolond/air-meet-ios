import UIKit

extension String {
    
    static let accountKey: String = "account"
    static let accountImageName: String = "account-image.png"
    
    func size(for font: UIFont) -> CGSize {
        let attributes = [NSAttributedString.Key.font : font as Any]
        return size(withAttributes: attributes)
    }
}
