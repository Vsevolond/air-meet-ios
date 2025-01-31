import Foundation
import MultipeerConnectivity

// MARK: - Nearby Advertiser Delegate Protocol

protocol NearbyAdvertiserDelegate: AnyObject {
    
    func didReceiveInvitation(fromPeer peerID: MCPeerID, invitationHandler: @escaping (Bool, MCSession?) -> Void)
}

// MARK: - Nearby Advertiser

final class NearbyAdvertiser: NSObject {
    
    // MARK: - Internal Properties
    
    weak var delegate: NearbyAdvertiserDelegate?
    
    // MARK: - Private Properties
    
    private let peerID: MCPeerID
    private let discoveryInfo: [String: String]
    
    private lazy var advertiser: MCNearbyServiceAdvertiser = {
        let advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: discoveryInfo, serviceType: .mcServiceType)
        advertiser.delegate = self
        
        return advertiser
    }()
    
    // MARK: - Initializers
    
    init(peerID: MCPeerID, discoveryInfo: [String : String]) {
        self.peerID = peerID
        self.discoveryInfo = discoveryInfo
    }
    
    // MARK: - Internal Methods
    
    func start() { advertiser.startAdvertisingPeer() }
    
    func stop() { advertiser.stopAdvertisingPeer() }
}

// MARK: - Extensions

extension NearbyAdvertiser: MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, 
                    didReceiveInvitationFromPeer peerID: MCPeerID,
                    withContext context: Data?,
                    invitationHandler: @escaping (Bool, MCSession?) -> Void
    ) {
        delegate?.didReceiveInvitation(fromPeer: peerID, invitationHandler: invitationHandler)
    }
}
