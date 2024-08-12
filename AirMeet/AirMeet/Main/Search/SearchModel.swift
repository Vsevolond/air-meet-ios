import SwiftUI
import Combine

// MARK: - Search Model

final class SearchModel: ObservableObject {
    
    // MARK: - Private Properties
    
    private let usersManager: UsersManager
    
    @Published private var users: [String] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Internal Properties
    
    var isSearching: Bool = false
    
    var nearbyUsers: [UserProfile] { users.compactMap { usersManager.getProfile(ofUser: $0) } }
    
    // MARK: - Initializers
    
    init(usersManager: UsersManager) {
        self.usersManager = usersManager
        
        usersManager.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (userID, state) in
                self?.handle(user: userID, state: state)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Internal Methods
    
    func startSearching() {
        isSearching = true
        usersManager.startSearching()
    }
    
    // MARK: - Private Methods
    
    private func handle(user userID: String, state: UsersManager.UserState) {
        switch state {
            
        case .lost:
            guard let index = users.firstIndex(of: userID) else { return }
            users.remove(at: index)
            
        case .found:
            withAnimation {
                users.insert(userID, at: 0)
            }
        }
    }
}
