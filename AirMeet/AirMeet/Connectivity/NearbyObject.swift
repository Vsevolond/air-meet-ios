import Foundation
import MultipeerConnectivity
import Combine

// MARK: - Nearby Object Delegate Protocol

protocol NearbyObjectDelegate: AnyObject {
    
    func didConnected(toPeer peerID: MCPeerID)
    func invite(peer peerID: MCPeerID, toSession session: MCSession)
    func didReceive(object: TransferObject, fromPeer peerID: MCPeerID)
}

// MARK: - Nearby Object

final class NearbyObject: NSObject {
    
    // MARK: - Type Properties

    
    enum NearbyObjectState {
        
        case lost, disconnected, connecting, connected
    }
    
    // MARK: - Internal Properties
    
    weak var delegate: NearbyObjectDelegate? { didSet { setStateHandler() } }
    
    // MARK: - Private Properties
    
    private let internalPeer: MCPeerID
    private let nearbyPeer: MCPeerID
    
    private var state: CurrentValueSubject<NearbyObjectState, Never> = .init(.disconnected)
    
    private lazy var session: MCSession = {
        let session = MCSession(peer: internalPeer)
        session.delegate = self
        
        return session
    }()
    
    private var onStateSubscription: AnyCancellable?
    
    // MARK: - Initializers
    
    init(internalPeer: MCPeerID, nearbyPeer: MCPeerID) {
        self.internalPeer = internalPeer
        self.nearbyPeer = nearbyPeer
        super.init()
    }
    
    // MARK: - Internal Methods
    
    func didFound() { state.value = .disconnected }
    
    func didLost() { state.value = .lost }
    
    func handleInvitation(_ invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        guard state.value == .disconnected || state.value == .lost else { return } // lost???
        invitationHandler(true, session)
    }
    
    func send(object: TransferObject) {
        guard state.value == .connected, let data = try? JSONEncoder().encode(object) else { return }
        do {
            try session.send(data, toPeers: [nearbyPeer], with: .reliable)
            print("send data to peer: \(nearbyPeer.displayName)")
            
        } catch {
            print("error send data to peer: \(nearbyPeer.displayName)")
            print(error.localizedDescription)
        }
    }
    
    private func setStateHandler() {
        onStateSubscription = state.sink { [self] state in
            handleState(state)
        }
    }
    
    private func handleState(_ objectState: NearbyObjectState) {
        switch objectState {
            
        case .lost: 
            print("lost peer: \(nearbyPeer.displayName)")
            session.disconnect()
            
        case .disconnected:
            print("disconnected peer: \(nearbyPeer.displayName)")
            delegate?.invite(peer: nearbyPeer, toSession: session)
            
        case .connected: 
            print("connected peer: \(nearbyPeer.displayName)")
            delegate?.didConnected(toPeer: nearbyPeer)
            
        default: return
        }
    }
}

// MARK: - Extensions

extension NearbyObject: MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
            
        case .notConnected: self.state.value = .disconnected
        case .connected: self.state.value = .connected
        case .connecting: self.state.value = .connecting
            
        @unknown default: print("unknown state")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        guard let object = try? JSONDecoder().decode(TransferObject.self, from: data) else { return }
        print("received data from peer: \(peerID.displayName)")
        delegate?.didReceive(object: object, fromPeer: peerID)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: (any Error)?) {}
}
