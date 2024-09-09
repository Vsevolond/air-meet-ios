import UIKit
import SwiftUI
import SwiftData

// MARK: - Main Container

struct MainContainer {
    
    @MainActor
    static func build(with profile: UserProfile, container: ModelContainer) -> UIViewController {
        
        let nearbyManager = NearbyManager(userID: profile.id, discoveryInfo: profile.discoveryInfo)
        let usersManager = UsersManager(internalProfile: profile, nearbyManager: nearbyManager)
        nearbyManager.delegate = usersManager
        
        let searchModel = SearchModel(usersManager: usersManager)
        let searchView = SearchView(model: searchModel)
        
        let dataSource = DataSource(container: container)
        let chatsModel = ChatsModel(usersManager: usersManager, nearbyManager: nearbyManager, dataSource: dataSource)
        usersManager.delegate = chatsModel
        
        let chatsView = ChatsView(model: chatsModel)
        let profileView = ProfileView(profile: profile, type: .withSettings)
        
        let mainTabView = MainTabView(
            searchView: searchView,
            chatsView: chatsView,
            profileView: profileView,
            container: container
        )
        let mainViewController = UIHostingController(rootView: mainTabView)
        
        return mainViewController
    }
}
