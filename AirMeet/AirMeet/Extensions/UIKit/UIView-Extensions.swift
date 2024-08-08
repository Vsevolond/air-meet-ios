import UIKit
import SwiftUI

extension UIView {
    
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { subview in
            addSubview(subview)
        }
    }
}
