import UIKit
import SnapKit

// MARK: - Detail Age Collection Cell

final class DetailAgeCollectionCell: UICollectionViewCell {
    
    // MARK: - Type Properties
    
    static let identifier: String = "DetailAgeCollectionCell"
    
    // MARK: - Internal Properties
    
    var onAgeUpdate: ((Int) -> Void)?
    
    // MARK: - Private Properties
    
    private let agePickerView: UIPickerView = UIPickerView()
    private let titleLabel: UILabel = UILabel()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal Properties
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
    
    // MARK: - Private Properties
    
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
        
        agePickerView.delegate = self
        agePickerView.dataSource = self
        agePickerView.translatesAutoresizingMaskIntoConstraints = false
        agePickerView.transform = .init(rotationAngle: -.pi / 2)
        
        addSubviews([titleLabel, agePickerView])
    }
    
    private func layout() {
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leftMargin.equalToSuperview().offset(10)
            make.width.lessThanOrEqualTo(snp.width).dividedBy(2)
            make.height.equalTo(snp.height).inset(10)
        }
        
        agePickerView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(5)
            make.top.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
            make.width.equalTo(snp.height).inset(10)
        }
    }
}

// MARK: - Extensions

extension DetailAgeCollectionCell: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { 100 }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let rowView = UIView()
        rowView.frame = .init(x: 0, y: 0, width: pickerView.bounds.height, height: pickerView.bounds.height)
        
        let rowLabel = UILabel()
        rowLabel.frame = rowView.bounds
        rowLabel.textAlignment = .center
        rowLabel.textColor = .appColor(.black)
        rowLabel.text = "\(row + 1)"
        
        rowView.addSubview(rowLabel)
        rowView.transform = .init(rotationAngle: .pi / 2)
        
        return rowView
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        onAgeUpdate?(row + 1)
    }
}
