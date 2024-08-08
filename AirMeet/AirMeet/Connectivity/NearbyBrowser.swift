import Foundation
import MultipeerConnectivity

// MARK: - Nearby Browser Delegate Protocol

protocol NearbyBrowserDelegate: AnyObject {
    
    func didFound(peer peerID: MCPeerID, withInfo discoveryInfo: [String: String])
    func didLost(peer peerID: MCPeerID)
}

// MARK: - NearbyBrowser

final class NearbyBrowser: NSObject {
    
    // MARK: - Internal Properties
    
    weak var delegate: NearbyBrowserDelegate?
    
    // MARK: - Private Properties
    
    private let peerID: MCPeerID
    
    private lazy var browser: MCNearbyServiceBrowser = {
        let browser = MCNearbyServiceBrowser(peer: peerID, serviceType: .mcServiceType)
        browser.delegate = self
        
        return browser
    }()
    
    // MARK: - Initializers
    
    init(peerID: MCPeerID) { self.peerID = peerID }
    
    // MARK: - Internal Methods
    
    func start() { browser.startBrowsingForPeers() }
    
    func stop() { browser.stopBrowsingForPeers() }
    
    func invite(peer peerID: MCPeerID, toSession session: MCSession) {
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10.0)
    }
}

// MARK: - Extensions

extension NearbyBrowser: MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        guard let info else { return }
        delegate?.didFound(peer: peerID, withInfo: info)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        delegate?.didLost(peer: peerID)
    }
}
