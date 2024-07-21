import UIKit

extension String {
    
    static let accountKey: String = "account"
    static let accountImageName: String = "account-image.png"
    static let deviceIdentifierKey: String = "device-identifier"
    
    func size(for font: UIFont) -> CGSize {
        let attributes = [NSAttributedString.Key.font : font as Any]
        return size(withAttributes: attributes)
    }
    
    var imageFromBase64: UIImage? {
        guard let imageData = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else {
            return .none
        }
        
        return UIImage(data: imageData)
    }
}
