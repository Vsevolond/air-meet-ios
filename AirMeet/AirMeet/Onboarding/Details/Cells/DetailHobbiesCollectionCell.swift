import UIKit
import SnapKit

// MARK: - Delegate Protocol

protocol DetailHobbiesCollectionCellDelegate: AnyObject {
    
    func didTapAddHobbiesButton()
}

// MARK: - Detail Hobbies Collection Cell

final class DetailHobbiesCollectionCell: UICollectionViewCell {
    
    // MARK: - Type Properties
    
    static let identifier: String = "DetailHobbiesCollectionCell"
    
    // MARK: - Internal Properties
    
    weak var delegate: DetailHobbiesCollectionCellDelegate?
    
    // MARK: - Private Properties
    
    private let titleLabel: UILabel = UILabel()
    private let addHobbiesButton: UIButton = UIButton()
    
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
        titleLabel.text = title
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
        
        titleLabel.textColor = .appColor(.black)
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textAlignment = .left
        
        var configuration = UIButton.Configuration.plain()
        var container = AttributeContainer()
        container.font = .boldSystemFont(ofSize: 14)
        configuration.attributedTitle = .init(Constants.addHobbiesTitle, attributes: container)
        configuration.baseForegroundColor = .appColor(.magenta)
        
        addHobbiesButton.configuration = configuration
        addHobbiesButton.addAction(UIAction { [weak self] _ in
            self?.delegate?.didTapAddHobbiesButton()
        }, for: .touchUpInside)
        
        addSubviews([titleLabel, addHobbiesButton])
    }
    
    private func layout() {
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leftMargin.equalToSuperview().offset(10)
            make.width.lessThanOrEqualTo(snp.width).dividedBy(2)
            make.height.equalTo(snp.height).inset(10)
        }
        
        addHobbiesButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(5)
            make.width.lessThanOrEqualTo(snp.width).dividedBy(2)
            make.height.equalTo(snp.height).inset(10)
        }
    }
}

// MARK: - Constants

private enum Constants {
    
    static let addHobbiesTitle: String = "Добавить"
}
