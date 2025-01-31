import SwiftUI

extension View {
    
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
    
    func keyboardHeight(_ state: Binding<CGFloat>) -> some View {
        self.modifier(KeyboardHeightModifier(keyboardHeight: state))
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
    
    func foregroundColor(light lightModeColor: Color, dark darkModeColor: Color) -> some View {
        modifier(ForegroundColorModifier(
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
    
    @ViewBuilder func `if`<TrueContent: View>(
        _ condition: Bool, then thenTransform: (Self) -> TrueContent) -> some View
    {
        if condition {
            thenTransform(self)
            
        } else {
            self
        }
    }
}

private struct SizePreferenceKey: PreferenceKey {
    
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

