import UIKit

extension CGSize {
    
    init(by side: CGFloat) {
        self.init(width: side, height: side)
    }
    
    static func * (size: CGSize, factor: CGFloat) -> CGSize {
        .init(width: size.width * factor, height: size.height * factor)
    }
}
