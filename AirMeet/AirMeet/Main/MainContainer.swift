import UIKit

// MARK: - Main Container

final class MainContainer {
    
    static func build(with account: Account) -> UIViewController {
        let searchViewController = SearchViewController()
        searchViewController.tabBarItem.title = Constants.searchTitle
        searchViewController.tabBarItem.image = .init(systemName: Constants.searchImageName)
        
        let chatsViewController = ChatsViewController()
        chatsViewController.tabBarItem.title = Constants.chatsTitle
        chatsViewController.tabBarItem.image = .init(systemName: Constants.chatsImageName)
        
        let settingsViewController = SettingsViewController(account: account)
        settingsViewController.tabBarItem.title = Constants.settingsTitle
        settingsViewController.tabBarItem.image = .init(systemName: Constants.settingsImageName)
        
        let mainTabBarController = UITabBarController()
        mainTabBarController.tabBar.tintColor = .appColor(.magenta)
        mainTabBarController.setViewControllers([searchViewController, chatsViewController, settingsViewController], animated: false)
        
        return mainTabBarController
    }
}

// MARK: - Constants

private enum Constants {
    
    static let searchTitle: String = "Люди"
    static let chatsTitle: String = "Чаты"
    static let settingsTitle: String = "Настройки"
    
    static let searchImageName: String = "person.2.fill"
    static let chatsImageName: String = "message.fill"
    static let settingsImageName: String = "gear"
}
