import UIKit
import MultipeerConnectivity

class ViewController: UIViewController {
    
    private let stateLabel: UILabel = UILabel()
    private let connectButton: UIButton = UIButton()
    private let disconnectButton: UIButton = UIButton()
    private let sendButton: UIButton = UIButton()
    
    private let serviceType: String = "mctest"
    
    private var session: MCSession?
    private var browser: MCNearbyServiceBrowser?
    private var advertiser: MCNearbyServiceAdvertiser?
    private let peerID: MCPeerID = .init(displayName: UIDevice.current.name)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        session = .init(peer: peerID, securityIdentity: nil, encryptionPreference: .none)
        session?.delegate = self
        startBrowser()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        layout()
    }
    
    private func setup() {
        view.backgroundColor = .white
        
        stateLabel.textAlignment = .center
        stateLabel.textColor = .black
        stateLabel.font = .boldSystemFont(ofSize: 20)
        
        connectButton.setTitle("Connect", for: .normal)
        connectButton.setTitleColor(.link, for: .normal)
        connectButton.setTitleColor(.systemGray, for: .highlighted)
        connectButton.addTarget(self, action: #selector(didTapConnectButton), for: .touchUpInside)
        
        disconnectButton.setTitle("Disconnect", for: .normal)
        disconnectButton.setTitleColor(.link, for: .normal)
        disconnectButton.setTitleColor(.systemGray, for: .highlighted)
        disconnectButton.addTarget(self, action: #selector(didTapDisconnectButton), for: .touchUpInside)
        
        sendButton.setTitle("Send message", for: .normal)
        sendButton.setTitleColor(.link, for: .normal)
        sendButton.setTitleColor(.systemGray, for: .highlighted)
        sendButton.addTarget(self, action: #selector(didTapSendButton), for: .touchUpInside)
    }
    
    private func layout() {
        stateLabel.frame = .init(x: 0, y: view.safeAreaInsets.top + 50, width: view.bounds.width, height: 40)
        connectButton.frame = .init(x: view.bounds.width / 2 - 50, y: stateLabel.frame.maxY + 50, width: 100, height: 40)
        disconnectButton.frame = .init(x: view.bounds.width / 2 - 50, y: connectButton.frame.maxY + 50, width: 100, height: 40)
        sendButton.frame = .init(x: view.bounds.width / 2 - 100, y: disconnectButton.frame.maxY + 50, width: 200, height: 40)
        
        view.addSubviews([stateLabel, connectButton, disconnectButton, sendButton])
    }
    
    @objc private func didTapConnectButton() {
        stopBrowsingAndAdvertising()
        startAdvertiser()
    }
    
    @objc private func didTapDisconnectButton() {
        session?.connectedPeers.forEach({ peerID in
            session?.cancelConnectPeer(peerID)
        })
        
        stopBrowsingAndAdvertising()
        startBrowser()
    }
    
    @objc private func didTapSendButton() {
        send(message: "Hello from \(peerID.displayName)")
    }
}

private extension ViewController {
    
    func startAdvertiser() {
        advertiser = .init(peer: peerID, discoveryInfo: nil, serviceType: serviceType)
        advertiser?.delegate = self
        advertiser?.startAdvertisingPeer()
    }
    
    func startBrowser() {
        browser = .init(peer: peerID, serviceType: serviceType)
        browser?.delegate = self
        browser?.startBrowsingForPeers()
    }
    
    func stopBrowsingAndAdvertising() {
        if let browser {
            browser.stopBrowsingForPeers()
        }
        
        if let advertiser {
            advertiser.stopAdvertisingPeer()
        }
        
        session?.disconnect()
    }
    
    func send(message: String) {
        guard let connectedPeers = session?.connectedPeers,
              let messageData = try? JSONEncoder().encode(message) else { return }
        
        do {
            try session?.send(messageData, toPeers: connectedPeers, with: .reliable)
            
        } catch {}
    }
}

extension ViewController: MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
            
        case .notConnected:
            DispatchQueue.main.async {
                self.stateLabel.text = "Not connected"
            }
            
        case .connecting:
            DispatchQueue.main.async {
                self.stateLabel.text = "Connecting"
            }
            
        case .connected:
            DispatchQueue.main.async {
                self.stateLabel.text = "Connected"
            }
            
        @unknown default:
            DispatchQueue.main.async {
                self.stateLabel.text = "Fatal error"
            }
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            guard let message = try? JSONDecoder().decode(String.self, from: data) else { return }
            let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .cancel))
            self.present(alert, animated: true)
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: (any Error)?) {
        
    }
}

extension ViewController: MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, session)
    }
}

extension ViewController: MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        guard let session else { return }
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10.0)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        
    }
}

