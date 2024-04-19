import UIKit
import SnapKit
import Lottie

// MARK: - Meet View Controller

final class MeetViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let animationView: LottieAnimationView = .init(asset: Constants.animationName)
    private let createProfileButton: UIButton = UIButton()
    
    private var onboardingNavigationController: UINavigationController = UINavigationController()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didUserSignedUp), name: .userSignedUp, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .userSignedUp, object: nil)
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        animationView.stop()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationView.play()
    }
    
    // MARK: - Private Methods
    
    private func setup() {
        view.backgroundColor = .appColor(.white)
        
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        
        var configuration = UIButton.Configuration.filled()
        var container = AttributeContainer()
        container.font = .boldSystemFont(ofSize: 18)
        configuration.attributedTitle = .init(Constants.createProfileTitle, attributes: container)
        configuration.cornerStyle = .capsule
        configuration.baseBackgroundColor = .appColor(.gray)
        configuration.baseForegroundColor = .appColor(.magenta)
        
        createProfileButton.configuration = configuration
        createProfileButton.addTarget(self, action: #selector(didButtonTapped), for: .touchUpInside)
        
        view.addSubviews([animationView, createProfileButton])
    }
    
    private func layout() {
        animationView.snp.makeConstraints { make in
            make.topMargin.equalTo(view.safeAreaInsets.top).offset(50)
            make.centerX.equalToSuperview()
            make.height.equalTo(view.bounds.width)
            make.width.equalToSuperview()
        }
        
        createProfileButton.snp.makeConstraints { make in
            make.bottomMargin.equalTo(view.safeAreaInsets.bottom).inset(100)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalToSuperview().inset(100)
        }
    }
    
    @objc private func didButtonTapped() {
        let detailsViewController = DetailsViewController()
        onboardingNavigationController = UINavigationController(rootViewController: detailsViewController)
        onboardingNavigationController.modalPresentationStyle = .fullScreen
        onboardingNavigationController.modalTransitionStyle = .coverVertical
        onboardingNavigationController.navigationBar.tintColor = .appColor(.cyan)
        onboardingNavigationController.navigationBar.prefersLargeTitles = true
        
        present(onboardingNavigationController, animated: true)
    }
    
    @objc private func didUserSignedUp(notification: Notification) {
        guard let account = notification.object as? Account else { return }
        print(account.name)
        
        onboardingNavigationController.popToRootViewController(animated: true)
        onboardingNavigationController.dismiss(animated: true)
    }
}

// MARK: - Constants

private enum Constants {
    
    static let animationName: String = "dog-animation"
    static let createProfileTitle: String = "Создать профиль"
}
