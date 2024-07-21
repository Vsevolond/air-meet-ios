import SwiftUI

// MARK: - Search Model

final class SearchModel: ObservableObject {
    
    @Published var nearbyUsers: [String: AccountInfo] = [:]
    @Published var invitations: [String: AccountInfo] = [:]
    
    private var manager: ConnectivityManager
    
    var isSearchingStarted: Bool = false
    
    init(manager: ConnectivityManager) {
        self.manager = manager
        manager.searchDelegate = self
    }
    
    func startSearching() {
        manager.startAdvertising()
        manager.startBrowsing()
        
        isSearchingStarted = true
    }
    
    func didReceiveInvitation(from userID: String) {
        print("invitation from: \(userID)")
    }
    
    func invite(userID: String) {
        manager.invitePeer(with: userID)
    }
}

// MARK: - Extensions

extension SearchModel: ConnectivitySearchDelegate {
    
    func didFound(id: String, with info: [String : String]) {
        guard let info = AccountInfo(dict: info) else {
            print("cannot get info: \(info)")
            return
        }
        nearbyUsers[id] = info
    }
    
    func didLost(id: String) {
        nearbyUsers.removeValue(forKey: id)
    }
}
