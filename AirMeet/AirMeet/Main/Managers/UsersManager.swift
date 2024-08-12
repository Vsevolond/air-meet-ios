import SwiftUI
import Combine

// MARK: - Users Manager Delegate

protocol UsersManagerDelegate: AnyObject {
    
    func didReceive(message messageData: Data, fromUser userID: String)
}

// MARK: - Users Manager

final class UsersManager: ObservableObject {
    
    // MARK: - Type Properties
    
    enum UserState {
        
        case lost, found
    }
    
    // MARK: - Internal Properties
    
    weak var delegate: UsersManagerDelegate?
    
    var statePublisher = PassthroughSubject<(userID: String, state: UserState), Never>()
    
    // MARK: - Private Properties
    
    private var nearbyUsers: [String: UserProfile] = [:]
    
    private let internalProfile: UserProfile
    private let nearbyManager: NearbyManager
    
    // MARK: - Initializers
    
    init(internalProfile: UserProfile, nearbyManager: NearbyManager) {
        self.internalProfile = internalProfile
        self.nearbyManager = nearbyManager
    }
    
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
        statePublisher.send((userID, .lost))
        nearbyUsers.removeValue(forKey: userID)
    }
    
    func didConnected(toUser userID: String) {
        statePublisher.send((userID, .found))
        
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
            delegate?.didReceive(message: object.data, fromUser: userID)
        }
    }
}
