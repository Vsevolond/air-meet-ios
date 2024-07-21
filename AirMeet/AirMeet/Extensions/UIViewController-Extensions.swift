import SwiftUI

struct ViewControllerHolder {
    
    weak var value: UIViewController?
}

struct ViewControllerKey: EnvironmentKey {
    
    static var defaultValue: ViewControllerHolder {
        ViewControllerHolder(value: UIApplication.shared.currentWindow?.rootViewController)
    }
}

extension UIViewController {
    
    func present<Content: View>(
        style: UIModalPresentationStyle = .automatic,
        transitionStyle: UIModalTransitionStyle = .coverVertical,
        @ViewBuilder builder: () -> Content
    ) {
        let presented = UIHostingController(rootView: AnyView(EmptyView()))
        
        presented.modalPresentationStyle = style
        presented.modalTransitionStyle = transitionStyle
        presented.view.backgroundColor = .black.withAlphaComponent(0.5)
        presented.rootView = AnyView(
            builder()
                .environment(\.viewController, presented)
        )
        
        self.present(presented, animated: true)
    }
    
    func present(
        style: UIModalPresentationStyle = .automatic,
        transitionStyle: UIModalTransitionStyle = .coverVertical,
        viewController presented: UIViewController
    ) {
        presented.modalPresentationStyle = style
        presented.modalTransitionStyle = transitionStyle
        
        self.present(presented, animated: true)
    }
}
