import SwiftUI

// MARK: - Search Model

final class SearchModel: ObservableObject {
    
    // MARK: - Private Properties
    
    private let usersManager: UsersManager
    
    @Published private var users: [String] = []
    
    // MARK: - Internal Properties
    
    var isSearching: Bool = false
    
    var nearbyUsers: [UserProfile] { users.compactMap { usersManager.getProfile(ofUser: $0) } }
    
    // MARK: - Initializers
    
    init(usersManager: UsersManager) {
        self.usersManager = usersManager
        usersManager.searchDelegate = self
    }
    
    func startSearching() {
        isSearching = true
        usersManager.startSearching()
    }
}

// MARK: - Extensions

extension SearchModel: UsersManagerSearchDelegate {
    
    func didFound(user userID: String) {
        withAnimation {
            users.insert(userID, at: 0)
        }
    }
    
    func didLost(user userID: String) {
        guard let index = users.firstIndex(of: userID) else { return }
        users.remove(at: index)
    }
}
