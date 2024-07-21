import SwiftUI

// MARK: - PhotoEditorView

struct PhotoEditorView: UIViewControllerRepresentable {
    
    // MARK: - Internal Properties
    
    @Binding var image: UIImage?
    let completion: (_ image: UIImage) -> Void
    
    // MARK: - Internal Methods
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = PhotoEditorViewController(image: image)
        viewController.delegate = context.coordinator
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    func makeCoordinator() -> Coordinator { Coordinator(parent: self) }
    
    // MARK: - Coordinator
    
    class Coordinator: PhotoEditorViewControllerDelegate {
        
        let parent: PhotoEditorView
        
        init(parent: PhotoEditorView) {
            self.parent = parent
        }
        
        func didSetImage(_ image: UIImage) {
            parent.completion(image)
        }
    }
}
