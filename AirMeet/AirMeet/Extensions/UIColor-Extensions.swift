import UIKit

extension UIColor {
    
    static func appColor(_ color: AppColor) -> UIColor {
        let value = color.value
        let red: CGFloat = value.red / 255
        let green: CGFloat = value.green / 255
        let blue: CGFloat = value.blue / 255
        
        return .init(red: red, green: green, blue: blue, alpha: 1)
    }
}
