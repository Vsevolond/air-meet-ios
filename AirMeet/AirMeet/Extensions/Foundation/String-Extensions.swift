import UIKit

extension String {
    
    static let profileKey: String = "profile"
    static let profileImageName: String = "profile-image.png"
    
    static let mcServiceType: String = "mctest"
    
    static let deviceIdentifier: String? = UIDevice.current.identifierForVendor?.uuidString
    static let uuid: String = UUID().uuidString
    
    func size(for font: UIFont) -> CGSize {
        let attributes = [NSAttributedString.Key.font : font as Any]
        return size(withAttributes: attributes)
    }
}
