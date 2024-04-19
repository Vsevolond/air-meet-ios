import UIKit
import SnapKit
import Combine

// MARK: - Details View Controller

final class DetailsViewController: UIViewController {
    
    // MARK: - Type Properties
    
    private enum DetailType: CaseIterable {
        
        case name
        case surname
        case age
        case hobbies
    }
    
    // MARK: - Private Properties
    
    private let account = Account(name: "", surname: "", age: 1, hobbies: [])
    private var subscription: AnyCancellable?
    
    private let detailsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(DetailCollectionCell.self, forCellWithReuseIdentifier: DetailCollectionCell.identifier)
        collectionView.register(DetailAgeCollectionCell.self, forCellWithReuseIdentifier: DetailAgeCollectionCell.identifier)
        collectionView.register(DetailHobbiesCollectionCell.self, forCellWithReuseIdentifier: DetailHobbiesCollectionCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        
        return collectionView
    }()
    
    private let nextButton: UIButton = UIButton()
    
    // MARK: - Internal Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layout()
    }
    
    // MARK: - Private Methods
    
    private func setup() {
        navigationItem.title = Constants.navigationTitle
        view.backgroundColor = .appColor(.white)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
        subscription = account.validSubject.sink(receiveValue: { isValid in
            self.nextButton.isEnabled = isValid
        })
        
        detailsCollectionView.backgroundColor = .clear
        detailsCollectionView.delegate = self
        detailsCollectionView.dataSource = self
        detailsCollectionView.contentInset = .init(top: 20, left: 0, bottom: 0, right: 0)
        
        var configuration = UIButton.Configuration.filled()
        var container = AttributeContainer()
        container.font = .boldSystemFont(ofSize: 14)
        configuration.attributedTitle = .init(Constants.nextButtonTitle, attributes: container)
        configuration.baseBackgroundColor = .appColor(.cyan)
        configuration.cornerStyle = .capsule
        
        nextButton.configuration = configuration
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        
        view.addSubviews([detailsCollectionView, nextButton])
    }
    
    private func layout() {
        detailsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(navigationController?.navigationBar.snp.bottom ?? view.safeAreaInsets.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.centerY).offset(120)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(detailsCollectionView.snp.bottom).offset(20)
            make.right.equalToSuperview().inset(20)
            make.width.lessThanOrEqualTo(100)
            make.height.equalTo(40)
        }
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func didTapNextButton() {
        let photoViewController = PhotoViewController(account: account)
        navigationController?.pushViewController(photoViewController, animated: true)
    }
}

// MARK: - Extensions

extension DetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        DetailType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = DetailType.allCases[indexPath.row]
        
        switch type {
            
        case .name:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCollectionCell.identifier,
                                                                for: indexPath) as? DetailCollectionCell else { return .init() }
            cell.configure(title: Constants.nameTitle)
            cell.onTextUpdate = { name in
                self.account.name = name
            }
            return cell
            
        case .surname:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCollectionCell.identifier,
                                                                for: indexPath) as? DetailCollectionCell else { return .init() }
            cell.configure(title: Constants.surnameTitle)
            cell.onTextUpdate = { surname in
                self.account.surname = surname
            }
            return cell
            
        case .age:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailAgeCollectionCell.identifier,
                                                                for: indexPath) as? DetailAgeCollectionCell else { return .init() }
            cell.configure(title: Constants.ageTitle)
            cell.onAgeUpdate = { age in
                self.account.age = age
            }
            return cell
            
        case .hobbies:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailHobbiesCollectionCell.identifier,
                                                                for: indexPath) as? DetailHobbiesCollectionCell else { return .init() }
            cell.configure(title: Constants.hobbieTitle)
            cell.delegate = self
            
            return cell
        }
    }
}

extension DetailsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.bounds.width - 20, height: 80)
    }
}

extension DetailsViewController: DetailHobbiesCollectionCellDelegate {
    
    func didTapAddHobbiesButton() {
        let detailHobbiesViewController = DetailHobbiesViewController(hobbies: account.hobbies)
        detailHobbiesViewController.delegate = self
        navigationController?.pushViewController(detailHobbiesViewController, animated: true)
    }
}

extension DetailsViewController: DetailHobbiesViewControllerDelegate {
    
    func didHobbiesChanged(hobbies: [Hobbie]) {
        account.hobbies = hobbies
    }
}

// MARK: - Constants

private enum Constants {
    
    static let nameTitle: String = "Имя"
    static let surnameTitle: String = "Фамилия"
    static let ageTitle: String = "Возраст"
    static let hobbieTitle: String = "Увлечения"
    
    static let navigationTitle: String = "О себе"
    static let nextButtonTitle: String = "Далее"
}
