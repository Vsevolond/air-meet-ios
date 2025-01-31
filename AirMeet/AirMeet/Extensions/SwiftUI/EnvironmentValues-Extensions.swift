import SwiftUI

extension EnvironmentValues {
    
    var viewController: UIViewController? {
        get { return self[ViewControllerKey.self].value }
        set { self[ViewControllerKey.self].value = newValue }
    }
    
    var tabSelection: Binding<MainTab> {
        get { return self[TabSelectionKey.self] }
        set { self[TabSelectionKey.self] = newValue }
    }
}
