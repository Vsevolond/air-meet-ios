import UIKit

extension UIImage {
    
    func cropped(to rect: CGRect) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: rect.size)
        
        let croppedImage = renderer.image { context in
            draw(at: .init(x: -rect.origin.x, y: -rect.origin.y))
        }
        
        return croppedImage
    }
}
