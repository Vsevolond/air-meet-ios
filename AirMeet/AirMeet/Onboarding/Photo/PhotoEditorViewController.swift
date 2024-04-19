import UIKit
import SnapKit

// MARK: - Delegate Protocol

protocol PhotoEditorViewControllerDelegate: AnyObject {
    
    func didSetImage(_ image: UIImage)
}

// MARK: - Photo Editor View Controller

final class PhotoEditorViewController: UIViewController {
    
    // MARK: - Internal Properties
    
    override var prefersStatusBarHidden: Bool { true }
    
    weak var delegate: PhotoEditorViewControllerDelegate?
    
    // MARK: - Private Properties
    
    private var image: UIImage
    private var imageOffset: CGPoint = .zero
    private var imageZoomScale: CGFloat = .zero
    
    private let scrollView: UIScrollView = UIScrollView()
    private let imageView: UIImageView = UIImageView()
    private let cropView: UIView = UIView()
    private let maskView: UIView = UIView()
    
    private let cancelButton: UIButton = UIButton()
    private let doneButton: UIButton = UIButton()
    
    // MARK: - Initializers
    
    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setCropView()
        setImage()
    }
    
    // MARK: - Private Methods
    
    private func setup() {
        view.backgroundColor = .appColor(.black)
        
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        cropView.isUserInteractionEnabled = false
        maskView.isUserInteractionEnabled = false
        
        var cancelConfiguration = UIButton.Configuration.plain()
        cancelConfiguration.image = UIImage(systemName: Constants.cancelImageName,
                                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 24))
        cancelConfiguration.baseForegroundColor = .appColor(.white)
        cancelConfiguration.imagePlacement = .all
        cancelButton.configuration = cancelConfiguration
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        
        var doneConfiguration = UIButton.Configuration.plain()
        doneConfiguration.image = UIImage(systemName: Constants.doneImageName,
                                          withConfiguration: UIImage.SymbolConfiguration(pointSize: 24))
        doneConfiguration.baseForegroundColor = .appColor(.cyan)
        doneConfiguration.imagePlacement = .all
        doneButton.configuration = doneConfiguration
        doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        
        view.addSubviews([scrollView, maskView, cancelButton, doneButton])
        scrollView.addSubview(imageView)
        maskView.addSubview(cropView)
    }
    
    private func layout() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaInsets.top)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview().inset(100)
        }
        
        imageView.snp.makeConstraints { make in
            make.margins.equalToSuperview()
        }
        
        maskView.snp.makeConstraints { make in
            make.leading.equalTo(scrollView.snp.leading)
            make.top.equalTo(scrollView.snp.top)
            make.trailing.equalTo(scrollView.snp.trailing)
            make.bottom.equalTo(scrollView.snp.bottom)
        }
        
        cropView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
            make.height.equalTo(scrollView.snp.width)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
            make.width.lessThanOrEqualTo(view.snp.width).dividedBy(2)
            make.height.equalTo(60)
        }
        
        doneButton.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom).offset(10)
            make.right.equalToSuperview().inset(20)
            make.width.lessThanOrEqualTo(view.snp.width).dividedBy(2)
            make.height.equalTo(60)
        }
    }
    
    private func setImage() {
        imageView.image = image
        
        let scale = max(cropView.frame.width / image.size.width, cropView.frame.height / image.size.height)
        let widthConstraint = image.size.width * scale
        let heightConstraint = image.size.height * scale
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(widthConstraint)
            make.height.equalTo(heightConstraint)
        }
        
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 5
        scrollView.zoomScale = 1
        imageZoomScale = 1
        
        let inset = (scrollView.frame.height - cropView.frame.height) / 2
        scrollView.contentInset = .init(top: inset, left: 0, bottom: inset, right: 0)
        imageOffset = .init(x: (widthConstraint - scrollView.frame.width) / 2, y: (heightConstraint - scrollView.frame.height) / 2)
        scrollView.contentOffset = imageOffset
    }
    
    private func setCropView() {
        let outerPath = UIBezierPath(rect: maskView.bounds)
        let circlePath = UIBezierPath(ovalIn: cropView.frame)
        outerPath.usesEvenOddFillRule = true
        outerPath.append(circlePath)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = outerPath.cgPath
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        maskLayer.fillColor = UIColor.appColor(.black).withAlphaComponent(0.4).cgColor
        maskView.layer.addSublayer(maskLayer)
    }
    
    private func getImageCropRect() -> CGRect {
        let imageScale: CGFloat = min(image.size.width / cropView.frame.width, image.size.height / cropView.frame.height)
        let zoomFactor = 1 / imageZoomScale
        
        let x = (imageOffset.x + cropView.frame.origin.x) * zoomFactor * imageScale
        let y = (imageOffset.y  + cropView.frame.origin.y) * zoomFactor * imageScale
        
        let width = cropView.frame.width * zoomFactor * imageScale
        let height = cropView.frame.height * zoomFactor * imageScale
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    @objc private func didTapCancelButton() {
        cancelButton.isEnabled = false
        dismiss(animated: true)
    }
    
    @objc private func didTapDoneButton() {
        doneButton.isEnabled = false
        
        let cropRect = getImageCropRect().integral
        let croppedImage = image.cropped(to: cropRect)
        
        dismiss(animated: true) { [weak self] in
            self?.delegate?.didSetImage(croppedImage)
        }
    }
}

// MARK: - Extensions

extension PhotoEditorViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? { imageView }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        imageOffset = scrollView.contentOffset
        imageZoomScale = scrollView.zoomScale
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        imageOffset = scrollView.contentOffset
    }
}

// MARK: - Constants

private enum Constants {
    
    static let cancelImageName: String = "xmark.circle"
    static let doneImageName: String = "checkmark.circle.fill"
}
