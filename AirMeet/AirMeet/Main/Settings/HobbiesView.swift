import UIKit
import SnapKit

// MARK: - Hobbies View

final class HobbiesView: UIView {
    
    // MARK: - Private Properties
    
    private let hobbies: [Hobbie]
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: Constants.cellID)
        collectionView.isScrollEnabled = false
        collectionView.allowsSelection = false
        collectionView.backgroundColor = .clear
        collectionView.contentMode = .topLeft
        collectionView.contentInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        
        return collectionView
    }()
    
    // MARK: - Initializers
    
    init(hobbies: [Hobbie]) {
        self.hobbies = hobbies
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    // MARK: - Private Methods
    
    private func layout() {
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Extensions

extension HobbiesView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { hobbies.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellID, for: indexPath)
        let hobbie = hobbies[indexPath.row]
        
        let label = UILabel()
        label.text = hobbie.rawValue
        label.textColor = .appColor(.black)
        label.textAlignment = .center
        label.font = Constants.labelFont
        label.backgroundColor = .appColor(.white)
        
        cell.layer.cornerRadius = hobbie.rawValue.size(for: Constants.labelFont).height / 2
        cell.clipsToBounds = true
        cell.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        return cell
    }
}

extension HobbiesView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let hobbie = hobbies[indexPath.row]
        let size = hobbie.rawValue.size(for: Constants.labelFont)
        
        return .init(width: size.width * 1.1, height: size.height * 1.5)
    }
}

// MARK: - Constants

private enum Constants {
    
    static let cellID: String = "HobbiesCollectionViewCell"
    static let labelFont: UIFont = .boldSystemFont(ofSize: 14)
}
