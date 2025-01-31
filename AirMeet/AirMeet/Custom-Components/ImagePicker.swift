import SwiftUI
import PhotosUI

// MARK: - ImagePicker

struct ImagePicker: UIViewControllerRepresentable {
    
    // MARK: - Private Properties
    
    private let config: PHPickerConfiguration = {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        
        config.filter = .images
        config.selectionLimit = 1
        config.preferredAssetRepresentationMode = .current
        
        return config
    }()
    
    // MARK: - Internal Properties
    
    @Binding var isPresented: Bool
    
    let completion: (_ result: PHPickerResult) -> Void
    
    // MARK: - Internal Methods
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = PHPickerViewController(configuration: config)
        viewController.modalPresentationStyle = .currentContext
        viewController.delegate = context.coordinator
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    func makeCoordinator() -> Coordinator { Coordinator(parent: self) }
    
    // MARK: - Coordinator
    
    class Coordinator: PHPickerViewControllerDelegate {
        
        let parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            if let result = results.first {
                parent.completion(result)
            }
            
            parent.isPresented = false
        }
    }
}
