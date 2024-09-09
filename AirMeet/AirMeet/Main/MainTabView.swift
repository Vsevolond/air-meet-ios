import SwiftUI
import SwiftData

// MARK: - Main Tab

enum MainTab {
    
    case search, chats, profile
}

// MARK: - Tab Selection Key

struct TabSelectionKey: EnvironmentKey {
    
    static var defaultValue: Binding<MainTab> = .constant(.search)
}

// MARK: - Main Tab View

struct MainTabView: View {
    
    // MARK: - Private Properties
    
    private var searchView: SearchView
    private var chatsView: ChatsView
    private var profileView: ProfileView
    private var container: ModelContainer
    
    @State private var tabSelection: MainTab = .search
    
    // MARK: - Initializers
    
    init(searchView: SearchView, chatsView: ChatsView, profileView: ProfileView, container: ModelContainer) {
        self.searchView = searchView
        self.chatsView = chatsView
        self.profileView = profileView
        self.container = container
    }
    
    // MARK: - View Body
    
    var body: some View {
        TabView(selection: $tabSelection) {
            
            searchView
                .tag(MainTab.search)
                .tabItem {
                    Label(Constants.searchTitle, systemImage: Constants.searchImageName)
                }
            
            chatsView
                .tag(MainTab.chats)
                .tabItem {
                    Label(Constants.chatsTitle, systemImage: Constants.chatsImageName)
                }
            
            profileView
                .tag(MainTab.profile)
                .tabItem {
                    Label(Constants.profileTitle, systemImage: Constants.profileImageName)
                }
        }
        .environment(\.tabSelection, $tabSelection)
        .modelContainer(container)
    }
}

// MARK: - Constants

private enum Constants {
    
    static let searchTitle: String = "Поиск"
    static let chatsTitle: String = "Чаты"
    static let profileTitle: String = "Профиль"
    
    static let searchImageName: String = "magnifyingglass"
    static let chatsImageName: String = "message.fill"
    static let profileImageName: String = "person.crop.circle.fill"
}
