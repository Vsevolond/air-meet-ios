import UIKit
import SnapKit

// MARK: - Settings View Controller

final class SettingsViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool { true }
    
    // MARK: - Private Properties
    
    private let account: Account
    
    private let nameLabel: UILabel = UILabel()
    
    private let imageView = UIImageView()
    private var heightConstraint: Constraint? = nil
    private var bottomConstraint: Constraint? = nil
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellID)
        
        return tableView
    }()
    
    // MARK: - Initializers
    
    init(account: Account) {
        self.account = account
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal Properties
    
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
        nameLabel.text = account.fullName
        nameLabel.textColor = .appColor(.white)
        nameLabel.font = .boldSystemFont(ofSize: 20)
        nameLabel.textAlignment = .left
        nameLabel.layer.shadowColor = .appColor(.black)
        nameLabel.layer.shadowOpacity = 1
        nameLabel.layer.shadowOffset = .zero
        nameLabel.layer.shadowRadius = 10
        
        
        imageView.contentMode = .scaleAspectFill
        imageView.image = AccountHelper.shared.getImage()
        
        let headerView = UIView(frame: .init(x: 0, y: 0, width: view.frame.width, height: view.frame.width))
        headerView.addSubviews([imageView, nameLabel])
        
        tableView.tableHeaderView = headerView
        tableView.backgroundColor = .appColor(.gray)
        tableView.contentInsetAdjustmentBehavior = .never
        
        view.addSubview(tableView)
    }
    
    private func layout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            
            bottomConstraint = make.bottom.equalToSuperview().constraint
            heightConstraint = make.height.equalToSuperview().constraint
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(10)
        }
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int { 2 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == .zero ? 1 : Settings.allCases.count - 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        section == .zero ? 20 : .zero
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        section == .zero ? UIView() : .none
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == .zero {
            let hobbiesViewController = UIViewController()
            let hobbiesView = HobbiesView(hobbies: account.hobbies)
            
            hobbiesViewController.view.backgroundColor = .appColor(.gray)
            hobbiesViewController.view.addSubview(hobbiesView)
            hobbiesView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            present(hobbiesViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellID, for: indexPath)
        var config = cell.defaultContentConfiguration()
        
        if indexPath.section == .zero {
            let setting = Settings.allCases[indexPath.row]
            
            config.text = setting.title
            config.textProperties.color = .appColor(.black)
            config.textProperties.font = .boldSystemFont(ofSize: 16)
            
            cell.accessoryType = .detailButton
            cell.tintColor = .lightGray
            cell.contentConfiguration = config
            
        } else {
            let setting = Settings.allCases[indexPath.row + 1]
            
            config.text = setting.title
            config.textProperties.font = .boldSystemFont(ofSize: 16)
            config.image = setting.image
            config.imageProperties.tintColor = setting.imageColor
            
            cell.contentConfiguration = config
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let headerView = tableView.tableHeaderView else { return }
        
        let offsetY = -scrollView.contentOffset.y
        let bottom = (offsetY >= 0) ? 0 : offsetY / 2
        let height = headerView.bounds.height + offsetY
        
        bottomConstraint?.deactivate()
        heightConstraint?.deactivate()
        
        imageView.snp.makeConstraints { make in
            bottomConstraint = make.bottom.equalTo(bottom).constraint
            heightConstraint = make.height.equalTo(height).constraint
        }
        
        headerView.clipsToBounds = (offsetY <= 0)
    }
}

// MARK: - Constants

private enum Constants {
    
    static let cellID: String = "SettingsTableViewCell"
}
