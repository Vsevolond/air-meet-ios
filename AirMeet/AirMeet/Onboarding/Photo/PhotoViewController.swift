import UIKit
import SnapKit
import PhotosUI

final class PhotoViewController: UIViewController {
    
    private let account: Account
    
    private let imageView: RoundedImageView = RoundedImageView()
    private let chooseButton: UIButton = UIButton()
    
    init(account: Account) {
        self.account = account
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layout()
    }
    
    private func setup() {
        view.backgroundColor = .appColor(.white)
        
        navigationItem.title = Constants.navigationTitle
        navigationItem.rightBarButtonItem = .init(title: Constants.navigationButtonTitle, style: .done, target: self, action: #selector(didTapDoneButton))
        navigationItem.rightBarButtonItem?.isEnabled = account.image != nil
        
        imageView.contentMode = account.image == nil ? .center : .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.tintColor = .appColor(.cyan)
        imageView.image = account.image ?? UIImage(systemName: Constants.mockImageName,
                                                   withConfiguration: UIImage.SymbolConfiguration(pointSize: 50))
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = .appColor(.gray)
        
        var configuration = UIButton.Configuration.plain()
        var container = AttributeContainer()
        container.font = .systemFont(ofSize: 16)
        configuration.attributedTitle = .init(Constants.chooseButtonTitle, attributes: container)
        configuration.baseForegroundColor = .appColor(.magenta)
        
        chooseButton.configuration = configuration
        chooseButton.addTarget(self, action: #selector(didTapChooseButton), for: .touchUpInside)
        
        view.addSubviews([imageView, chooseButton])
    }
    
    private func layout() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(navigationController?.navigationBar.snp.bottom ?? view.safeAreaInsets.top)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(view.snp.width).dividedBy(2)
        }
        
        chooseButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualToSuperview()
        }
    }
    
    private func openPhotoEditor(image: UIImage) {
        let photoEditorViewController = PhotoEditorViewController(image: image)
        photoEditorViewController.modalPresentationStyle = .fullScreen
        photoEditorViewController.modalTransitionStyle = .crossDissolve
        photoEditorViewController.delegate = self
        
        present(photoEditorViewController, animated: true)
    }
    
    @objc private func didTapChooseButton() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc private func didTapDoneButton() {
        guard let image = account.image, let encoded = try? JSONEncoder().encode(account) else { return }
        
        DispatchQueue.global().async {
            AccountHelper.shared.saveImage(image)
        }
        
        UserDefaults.standard.set(encoded, forKey: .accountKey)
        NotificationCenter.default.post(name: .userSignedUp, object: account)
    }
}

// MARK: - Extensions

extension PhotoViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let itemProvider = results.first?.itemProvider,
              itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier)
        else { return }
        
        let _ = itemProvider.loadDataRepresentation(for: .image) { data, error in
            guard let data, let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self.openPhotoEditor(image: image)
            }
        }
    }
}

extension PhotoViewController: PhotoEditorViewControllerDelegate {
    
    func didSetImage(_ image: UIImage) {
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
        
        navigationItem.rightBarButtonItem?.isEnabled = true
        account.image = image
    }
}

// MARK: - Constants

private enum Constants {
    
    static let mockImageName: String = "photo"
    static let chooseButtonTitle: String = "Выбрать фотографию"
    static let navigationTitle: String = "Фотография"
    static let navigationButtonTitle: String = "Готово"
}
