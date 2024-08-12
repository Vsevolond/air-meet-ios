import UIKit
import SwiftUI

// MARK: - Main Container

final class MainContainer {
    
    private var tabBarController: UITabBarController?
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(openChats), name: .openChatKey, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showTabBar), name: .showTabBarKey, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideTabBar), name: .hideTabBarKey, object: nil)
    }
    
    func build(with profile: UserProfile) -> UIViewController {
        
        let nearbyManager = NearbyManager(userID: profile.id, discoveryInfo: profile.discoveryInfo)
        let usersManager = UsersManager(internalProfile: profile, nearbyManager: nearbyManager)
        nearbyManager.delegate = usersManager
        
        let searchModel = SearchModel(usersManager: usersManager)
        let searchView = SearchView(model: searchModel)
        let searchViewController = UIHostingController(rootView: searchView)
        searchViewController.tabBarItem.title = Constants.searchTitle
        searchViewController.tabBarItem.image = .init(systemName: Constants.searchImageName)
        
        let chatsModel = ChatsModel(nearbyManager: nearbyManager, usersManager: usersManager)
        usersManager.delegate = chatsModel
        
        let chatsView = ChatsView(model: chatsModel)
        let chatsViewController = UIHostingController(rootView: chatsView)
        chatsViewController.tabBarItem.title = Constants.chatsTitle
        chatsViewController.tabBarItem.image = .init(systemName: Constants.chatsImageName)
        
        let profileView = ProfileView(profile: profile, type: .withSettings)
        let profileViewController = UIHostingController(rootView: profileView)
        profileViewController.tabBarItem.title = Constants.settingsTitle
        profileViewController.tabBarItem.image = .init(systemName: Constants.profileImageName)
        
        let mainTabBarController = UITabBarController()
        mainTabBarController.tabBar.tintColor = .systemBlue
        mainTabBarController.setViewControllers([searchViewController, chatsViewController, profileViewController], animated: false)
        
        
        self.tabBarController = mainTabBarController
        return mainTabBarController
    }
    
    @objc private func openChats() { tabBarController?.selectedIndex = 1 }
    @objc private func showTabBar() { tabBarController?.tabBar.isHidden = false }
    @objc private func hideTabBar() { tabBarController?.tabBar.isHidden = true }
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
