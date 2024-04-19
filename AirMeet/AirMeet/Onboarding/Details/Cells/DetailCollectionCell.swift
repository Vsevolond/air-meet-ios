import UIKit
import SnapKit

// MARK: - Detail Collection Cell

final class DetailCollectionCell: UICollectionViewCell {
    
    // MARK: - Type Properties
    
    static let identifier: String = "DetailCollectionCell"
    
    // MARK: - Internal Properties
    
    var onTextUpdate: ((String) -> Void)?
    
    // MARK: - Private Properties
    
    private let textField: UITextField = UITextField()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    func configure(title: String) {
        textField.placeholder = title
    }
    
    // MARK: - Private Methods
    
    private func setup() {
        backgroundColor = .appColor(.white)
        layer.cornerRadius = 10
        layer.shadowColor = .appColor(.gray)
        layer.shadowRadius = 20
        layer.shadowOpacity = 1
        layer.borderWidth = 1
        layer.borderColor = .appColor(.gray)
        
        textField.clearButtonMode = .whileEditing
        textField.addTarget(self, action: #selector(didTextUpdated), for: .editingChanged)
        
        addSubview(textField)
    }
    
    private func layout() {
        textField.snp.makeConstraints { make in
            make.margins.equalToSuperview().inset(5)
        }
    }
    
    @objc private func didTextUpdated() {
        guard let text = textField.text else { return }
        onTextUpdate?(text)
    }
}
