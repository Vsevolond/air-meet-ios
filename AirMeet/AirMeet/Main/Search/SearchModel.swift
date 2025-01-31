import SwiftUI
import Combine

// MARK: - Search Model

final class SearchModel: ObservableObject {
    
    // MARK: - Private Properties
    
    private let usersManager: UsersManager
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Internal Properties
    
    @Published var nearbyUsers: [String] = []
    var isSearching: Bool = false
    
    // MARK: - Initializers
    
    init(usersManager: UsersManager) {
        self.usersManager = usersManager
        
        usersManager.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handle(state: state)
            }
            .store(in: &cancellables)
    }
    
    func profile(ofUser userID: String) -> UserProfile? { usersManager.getProfile(ofUser: userID) }
    
    // MARK: - Internal Methods
    
    func startSearching() {
        isSearching = true
        usersManager.startSearching()
    }
    
    // MARK: - Private Methods
    
    private func handle(state: UsersManager.UserState) {
        switch state {
            
        case .lost(let userID):
            guard let index = nearbyUsers.firstIndex(of: userID) else { return }
            nearbyUsers.remove(at: index)
            
        case .found(let userID):
            withAnimation {
                nearbyUsers.insert(userID, at: 0)
            }
        }
    }
}
