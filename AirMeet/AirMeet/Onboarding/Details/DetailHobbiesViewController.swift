import UIKit
import SnapKit

// MARK: - Delegate Protocol

protocol DetailHobbiesViewControllerDelegate: AnyObject {
    
    func didHobbiesChanged(hobbies: [Hobbie])
}

// MARK: - Detail Hobbies View Controller

final class DetailHobbiesViewController: UIViewController {
    
    // MARK: - Type Properties
    
    private enum Section {
        
        case selected
        case all
    }
    
    // MARK: - Internal Properties
    
    weak var delegate: DetailHobbiesViewControllerDelegate?
    
    // MARK: - Private Properties
    
    private var selectedHobbies: [Hobbie]
    private var allHobbies: [Hobbie]
    
    private let hobbiesTableView: UITableView = UITableView()
    
    private lazy var dataSource = UITableViewDiffableDataSource<Section, String>(tableView: hobbiesTableView) { tableView, indexPath, _ in
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(UITableViewCell.self)", for: indexPath)
        var item: Hobbie
        
        if indexPath.section == 0 {
            item = self.selectedHobbies[indexPath.row]
            
        } else {
            item = self.allHobbies[indexPath.row]
        }
        
        var configuration = cell.defaultContentConfiguration()
        configuration.text = item.rawValue
        cell.contentConfiguration = configuration
       
        return cell
    }
    
    // MARK: - Initializers
    
    init(hobbies: [Hobbie]) {
        self.selectedHobbies = hobbies
        self.allHobbies = Hobbie.allCases.sorted(by: { $0.rawValue < $1.rawValue }).filter { !hobbies.contains($0) }
        
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
    
    // MARK: - Private Methods
    
    private func setup() {
        navigationItem.title = Constants.navigationTitle
        view.backgroundColor = .appColor(.white)
        
        hobbiesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "\(UITableViewCell.self)")
        hobbiesTableView.dataSource = dataSource
        hobbiesTableView.delegate = self
        
        view.addSubview(hobbiesTableView)
        updateDataSource(animated: false)
    }
    
    private func layout() {
        hobbiesTableView.snp.makeConstraints { make in
            make.top.equalTo(navigationController?.navigationBar.snp.bottom ?? view.safeAreaInsets.top)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview().inset(40)
        }
    }
    
    private func updateDataSource(animated: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        
        snapshot.appendSections([.selected, .all])
        snapshot.appendItems(selectedHobbies.map { $0.rawValue }, toSection: .selected)
        snapshot.appendItems(allHobbies.map { $0.rawValue }, toSection: .all)

        dataSource.apply(snapshot, animatingDifferences: animated)
    }
}

// MARK: - Extensions

extension DetailHobbiesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard indexPath.section != 0 else { return }
        
        let item = allHobbies[indexPath.row]
        allHobbies.remove(at: indexPath.row)
        selectedHobbies.append(item)
        
        delegate?.didHobbiesChanged(hobbies: selectedHobbies)
        updateDataSource(animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.section == 0 else { return .none }
        
        let action = UIContextualAction(style: .destructive, title: Constants.removeHobbieTitle) { [weak self] _, view, completion in
            guard let self else { return }
            
            view.isHidden = true
            
            let item = selectedHobbies[indexPath.row]
            selectedHobbies.remove(at: indexPath.row)
            allHobbies.insert(item, at: 0)
            
            delegate?.didHobbiesChanged(hobbies: selectedHobbies)
            updateDataSource(animated: true)
            completion(true)
        }
        
        return .init(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard !selectedHobbies.isEmpty else { return .none }
        return .init()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard !selectedHobbies.isEmpty else { return .zero }
        return 20
    }
}

// MARK: - Constants

private enum Constants {
    
    static let navigationTitle: String = "Увлечения"
    static let removeHobbieTitle: String = "Убрать"
}
