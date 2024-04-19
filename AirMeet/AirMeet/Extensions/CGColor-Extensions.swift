import UIKit

extension CGColor {
    
    static func appColor(_ color: AppColor) -> CGColor {
        UIColor.appColor(color).cgColor
    }
}
