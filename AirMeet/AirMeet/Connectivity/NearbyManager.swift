import Foundation
import MultipeerConnectivity

// MARK: - Nearby Manager Delegate

protocol NearbyManagerDelegate: AnyObject {
    
    func didFound(user userID: String, withInfo discoveryInfo: [String: String])
    func didLost(user userID: String)
    func didConnected(toUser userID: String)
    func didReceive(object: TransferObject, fromUser userID: String)
}

// MARK: - Nearby Manager

final class NearbyManager {
    
    // MARK: - Internal Properties
    
    weak var delegate: NearbyManagerDelegate?
    
    // MARK: - Private Properties
    
    private let internalPeer: MCPeerID
    private let advertiser: NearbyAdvertiser
    private let browser: NearbyBrowser
    
    private var nearbyObjects: [String: NearbyObject] = [:]
    
    // MARK: - Initializers
    
    init(userID: String, discoveryInfo: [String: String]) {
        self.internalPeer = MCPeerID(displayName: userID)
        self.advertiser = NearbyAdvertiser(peerID: internalPeer, discoveryInfo: discoveryInfo)
        self.browser = NearbyBrowser(peerID: internalPeer)
        
        advertiser.delegate = self
        browser.delegate = self
    }
    
    // MARK: - Internal Methods
    
    func start() {
        advertiser.start()
        browser.start()
    }
    
    func stop() {
        advertiser.stop()
        browser.stop()
    }
    
    func send(object: TransferObject, toUser userID: String) {
        guard let nearbyObject = nearbyObjects[userID] else { return }
        nearbyObject.send(object: object)
    }
    
    // MARK: - Private Methods
    
    private func makeNearbyObject(forPeer nearbyPeer: MCPeerID) -> NearbyObject {
        let nearbyObject = NearbyObject(internalPeer: internalPeer, nearbyPeer: nearbyPeer)
        nearbyObject.delegate = self
        
        return nearbyObject
    }
}

// MARK: - Extensions

extension NearbyManager: NearbyAdvertiserDelegate {
    
    func didReceiveInvitation(fromPeer peerID: MCPeerID, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        guard let nearbyObject = nearbyObjects[peerID.displayName] else { return }
        nearbyObject.handleInvitation(invitationHandler)
    }
}

extension NearbyManager: NearbyBrowserDelegate {
    
    func didFound(peer peerID: MCPeerID, withInfo discoveryInfo: [String : String]) {
        delegate?.didFound(user: peerID.displayName, withInfo: discoveryInfo)
        
        if let nearbyObject = nearbyObjects[peerID.displayName] {
            nearbyObject.didFound()
            
        } else {
            let nearbyObject = makeNearbyObject(forPeer: peerID)
            nearbyObjects[peerID.displayName] = nearbyObject
        }
    }
    
    func didLost(peer peerID: MCPeerID) {
        delegate?.didLost(user: peerID.displayName)
        
        guard let nearbyObject = nearbyObjects[peerID.displayName] else { return }
        nearbyObject.didLost()
        
        nearbyObjects.removeValue(forKey: peerID.displayName)
    }
}

extension NearbyManager: NearbyObjectDelegate {
    
    func didConnected(toPeer peerID: MCPeerID) {
        delegate?.didConnected(toUser: peerID.displayName)
    }
    
    func invite(peer peerID: MCPeerID, toSession session: MCSession) {
        browser.invite(peer: peerID, toSession: session)
    }
    
    func didReceive(object: TransferObject, fromPeer peerID: MCPeerID) {
        delegate?.didReceive(object: object, fromUser: peerID.displayName)
    }
}
