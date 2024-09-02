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
        
        case lost(_ userID: String)
        case found(_ userID: String)
    }
    
    // MARK: - Internal Properties
    
    weak var delegate: UsersManagerDelegate?
    
    var statePublisher = PassthroughSubject<UserState, Never>()
    
    // MARK: - Private Properties
    
    private var usersCache = NSCache<NSString, UserProfile>()
    
    private let internalProfile: UserProfile
    private let nearbyManager: NearbyManager
    
    // MARK: - Initializers
    
    init(internalProfile: UserProfile, nearbyManager: NearbyManager) {
        self.internalProfile = internalProfile
        self.nearbyManager = nearbyManager
    }
    
    // MARK: - Internal Methods
    
    func startSearching() { nearbyManager.start() }
    
    func getProfile(ofUser userID: String) -> UserProfile? {
        usersCache.object(forKey: userID as NSString)
    }
}

// MARK: - Extensions

extension UsersManager: NearbyManagerDelegate {
    
    func didFound(user userID: String, withInfo discoveryInfo: [String : String]) {
        guard usersCache.object(forKey: userID as NSString) == nil,
              let profile = UserProfile(id: userID, discoveryInfo: discoveryInfo)
        else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.usersCache.setObject(profile, forKey: userID as NSString)
        }
    }
    
    func didLost(user userID: String) {
        DispatchQueue.main.async { [weak self] in
            self?.statePublisher.send(.lost(userID))
            self?.usersCache.removeObject(forKey: userID as NSString)
        }
    }
    
    func didConnected(toUser userID: String) {
        DispatchQueue.main.async { [weak self] in
            self?.statePublisher.send(.found(userID))
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
            guard let nearbyUser = usersCache.object(forKey: userID as NSString), nearbyUser.additionalInfo == nil,
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
