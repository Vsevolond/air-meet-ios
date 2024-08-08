import SwiftUI

// MARK: - ForegroundColorModifier

struct ForegroundColorModifier: ViewModifier {
    
    @Environment(\.colorScheme) private var colorScheme
    
    var lightModeColor: Color
    var darkModeColor: Color
    
    func body(content: Content) -> some View {
        content.foregroundStyle(resolvedColor)
    }
    
    private var resolvedColor: Color {
        switch colorScheme {
            
        case .light:
            return lightModeColor
        case .dark:
            return darkModeColor
        @unknown default:
            return lightModeColor
            
        }
    }
}
