import Foundation
import SwiftUI

// MARK: - Chats Model

final class ChatsModel: ObservableObject {
    
    // MARK: - Internal Properties
    
    private let nearbyManager: NearbyManager
    @ObservedObject var usersManager: UsersManager
    
    @Published var chats: [String: MessagesChat] = [:]
    
    init(nearbyManager: NearbyManager, usersManager: UsersManager) {
        self.nearbyManager = nearbyManager
        self.usersManager = usersManager
    }
    
    func getProfile(ofUser userID: String) -> UserProfile {
        guard let profile = usersManager.getProfile(ofUser: userID) else {
            fatalError("cannot find user's profile")
        }
        
        return profile
    }
    
    func getChat(withUser userID: String) -> MessagesChat {
        if let chat = chats[userID] {
            return chat
            
        } else {
            let chat = MessagesChat(id: userID)
            chats[userID] = chat
            
            return chat
        }
    }
    
    func send(message messageObject: MessageObject, toUser userID: String) {
        guard let chat = chats[userID] else { return }
        chat.add(message: messageObject, type: .outcoming)
        
        DispatchQueue.global().async { [weak self] in
            guard let data = try? JSONEncoder().encode(messageObject) else { return }
            let transferObject = TransferObject(context: .message, data: data)
            
            self?.nearbyManager.send(object: transferObject, toUser: userID)
        }
    }
}

extension ChatsModel: UsersManagerDelegate {
    
    func didReceive(message messageData: Data, fromUser userID: String) {
        guard let messageObject = try? JSONDecoder().decode(MessageObject.self, from: messageData) else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            if let chat = chats[userID] {
                chat.add(message: messageObject, type: .incoming)
                
            } else {
                let chat = MessagesChat(id: userID)
                chat.add(message: messageObject, type: .incoming)
                
                chats[userID] = chat
            }
        }
    }
}
