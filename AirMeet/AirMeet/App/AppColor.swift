import Foundation

enum AppColor {
    
    case black
    case white
    case gray
    case cyan
    case magenta
    case blue
    
    var value: (red: CGFloat, green: CGFloat, blue: CGFloat) {
        switch self {
        case .black: return (1, 4, 0)
        case .white: return (255, 251, 252)
        case .gray: return (233, 233, 235)
        case .cyan: return (98, 187, 193)
        case .magenta: return (236, 5, 142)
        case .blue: return (52, 35, 166)
        }
    }
}
