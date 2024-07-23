import UIKit
import SwiftUI

// MARK: - Main Container

final class MainContainer {
    
    static func build(with account: Account) -> UIViewController {
        if account.image == nil {
            account.image = AccountHelper.shared.getImage()
        }
        
        let connectivityManager = ConnectivityManager(discoveryInfo: account.discoveryInfo.dict)
        
        let searchModel = SearchModel(manager: connectivityManager)
        let searchView = SearchView(model: searchModel)
        let searchViewController = UIHostingController(rootView: searchView)
        searchViewController.tabBarItem.title = Constants.searchTitle
        searchViewController.tabBarItem.image = .init(systemName: Constants.searchImageName)
        
        let chatsViewController = ChatsViewController()
        chatsViewController.tabBarItem.title = Constants.chatsTitle
        chatsViewController.tabBarItem.image = .init(systemName: Constants.chatsImageName)
        
        let profileView = ProfileView(account: account)
        let profileViewController = UIHostingController(rootView: profileView)
        profileViewController.tabBarItem.title = Constants.settingsTitle
        profileViewController.tabBarItem.image = .init(systemName: Constants.profileImageName)
        
        let mainTabBarController = UITabBarController()
        mainTabBarController.tabBar.tintColor = .systemBlue
        mainTabBarController.setViewControllers([searchViewController, chatsViewController, profileViewController], animated: false)
        
        return mainTabBarController
    }
}

// MARK: - Constants

private enum Constants {
    
    static let searchTitle: String = "Поиск"
    static let chatsTitle: String = "Чаты"
    static let settingsTitle: String = "Профиль"
    
    static let searchImageName: String = "magnifyingglass"
    static let chatsImageName: String = "message.fill"
    static let profileImageName: String = "person.crop.circle.fill"
}
