import UIKit
import SwiftUI

extension UIView {
    
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { subview in
            addSubview(subview)
        }
    }
}

extension View {
    
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
    
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
    
    public func foregroundLinearGradient(colors: [Color], startPoint: UnitPoint, endPoint: UnitPoint) -> some View {
        self.overlay {
            LinearGradient(
                colors: colors,
                startPoint: startPoint,
                endPoint: endPoint
            )
            .mask(self)
        }
    }
    
    func foregroundColor(light lightModeColor: Color, dark darkModeColor: Color) -> some View {
        modifier(AdaptiveForegroundColorModifier(
            lightModeColor: lightModeColor,
            darkModeColor: darkModeColor
        ))
    }
    
    @ViewBuilder func `if`<TrueContent: View, FalseContent: View>(
        _ condition: Bool, then thenTransform: (Self) -> TrueContent,
        else elseTransform: (Self) -> FalseContent) -> some View
    {
        if condition {
            thenTransform(self)
            
        } else {
            elseTransform(self)
        }
    }
}

private struct SizePreferenceKey: PreferenceKey {
    
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
