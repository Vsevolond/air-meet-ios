import Foundation
import MultipeerConnectivity

// MARK: - Delegate Protocol

protocol ConnectivitySearchDelegate: AnyObject {
    
    func didFound(id: String, with info: [String: String])
    func didLost(id: String)
    func didReceiveInvitation(from userID: String)
}

// MARK: - Connectivity Manager

final class ConnectivityManager: NSObject {
    
    // MARK: - Internal Properties
    
    weak var searchDelegate: ConnectivitySearchDelegate?
    
    // MARK: - Private Properties
    
    private let discoveryInfo: [String: String]
    
    private let serviceType: String = "mctest"
    private let peerID: MCPeerID = .init(displayName: UIDevice.current.identifierForVendor?.uuidString ?? UIDevice.current.name)
    private var peers: [String: MCPeerID] = [:]
    
    private lazy var session: MCSession = {
        let session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .none)
        session.delegate = self
        
        return session
    }()
    
    private lazy var advertiser: MCNearbyServiceAdvertiser = {
        let advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: discoveryInfo, serviceType: serviceType)
        advertiser.delegate = self
        
        return advertiser
    }()
    
    private lazy var assistant: MCAdvertiserAssistant = {
        let assistant = MCAdvertiserAssistant(serviceType: serviceType, discoveryInfo: discoveryInfo, session: session)
        assistant.delegate = self
        
        return assistant
    }()
    
    private lazy var browser: MCNearbyServiceBrowser = {
        let browser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType)
        browser.delegate = self
        
        return browser
    }()
    
    // MARK: - Initializers
    
    init(discoveryInfo: [String : String]) {
        self.discoveryInfo = discoveryInfo
        super.init()
    }
    
    // MARK: - Internal Methods
    
    func startAdvertising() {
        print("start advertising")
        advertiser.startAdvertisingPeer()
    }
    
    func startBrowsing() {
        print("start browsing")
        browser.startBrowsingForPeers()
    }
    
    func invitePeer(with id: String) {
        guard let mcPeerID = peers[id] else { return }
        browser.invitePeer(mcPeerID, to: session, withContext: nil, timeout: 10.0)
    }
}

// MARK: - Extensions

extension ConnectivityManager: MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: (any Error)?) {
        
    }
}

extension ConnectivityManager: MCNearbyServiceAdvertiserDelegate, MCAdvertiserAssistantDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        searchDelegate?.didReceiveInvitation(from: peerID.displayName)
    }
}

extension ConnectivityManager: MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("found peer: \(peerID)")
        
        guard let info else {
            print("there is no discovery info for peer: \(peerID)")
            return
        }
        
        searchDelegate?.didFound(id: peerID.displayName, with: info)
        peers.updateValue(peerID, forKey: peerID.displayName)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("lost peer: \(peerID)")
        
        searchDelegate?.didLost(id: peerID.displayName)
        peers.removeValue(forKey: peerID.displayName)
    }
}
