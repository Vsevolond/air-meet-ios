import Foundation

// MARK: - Users Manager Search Delegate

protocol UsersManagerSearchDelegate: AnyObject {
    
    func didFound(user userID: String)
    func didLost(user userID: String)
}

// MARK: - Users Manager

final class UsersManager {
    
    // MARK: - Internal Properties
    
    weak var searchDelegate: UsersManagerSearchDelegate?
    
    // MARK: - Private Properties
    
    private let internalProfile: UserProfile
    private var nearbyUsers: [String: UserProfile] = [:]
    
    private lazy var nearbyManager: NearbyManager = {
        let manager = NearbyManager(userID: internalProfile.id, discoveryInfo: internalProfile.discoveryInfo)
        manager.delegate = self
        
        return manager
    }()
    
    // MARK: - Initializers
    
    init(internalProfile: UserProfile) { self.internalProfile = internalProfile }
    
    // MARK: - Internal Methods
    
    func startSearching() { nearbyManager.start() }
    
    func getProfile(ofUser userID: String) -> UserProfile? { nearbyUsers[userID] }
}

// MARK: - Extensions

extension UsersManager: NearbyManagerDelegate {
    
    func didFound(user userID: String, withInfo discoveryInfo: [String : String]) {
        guard nearbyUsers[userID] == nil, let profile = UserProfile(id: userID, discoveryInfo: discoveryInfo) else { return }
        nearbyUsers[userID] = profile
    }
    
    func didLost(user userID: String) {
        searchDelegate?.didLost(user: userID)
        nearbyUsers.removeValue(forKey: userID)
    }
    
    func didConnected(toUser userID: String) {
        DispatchQueue.main.async { [weak self] in
            self?.searchDelegate?.didFound(user: userID)
        }
        
        guard let additionalInfo = internalProfile.additionalInfo,
              let infoData = try? JSONEncoder().encode(additionalInfo)
        else { return }
        
        let transferObject = TransferObject(context: .additionalInfo, data: infoData)
        nearbyManager.send(object: transferObject, toUser: userID)
    }
    
    func didReceive(object: TransferObject, fromUser userID: String) {
        switch object.context {
            
        case .additionalInfo:
            guard let nearbyUser = nearbyUsers[userID], nearbyUser.additionalInfo == nil,
                  let additionalInfo = try? JSONDecoder().decode(UserProfile.AdditionalInfo.self, from: object.data)
            else { return }
            
            DispatchQueue.main.async {
                nearbyUser.addInfo(additionalInfo)
            }
            
        case .message:
            guard let message = try? JSONDecoder().decode(Message.self, from: object.data) else { return }
            print("message from user(\(userID)): \(message.value)")
        }
    }
}
