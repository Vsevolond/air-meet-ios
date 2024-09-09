import SwiftUI
import SwiftData

// MARK: - Chats Model

final class ChatsModel: ObservableObject, UsersManagerDelegate {
    
    unowned var usersManager: UsersManager
    unowned var nearbyManager: NearbyManager
    
    @ObservationIgnored let dataSource: DataSource
    
    var chats: [Chat] = []
    
    init(usersManager: UsersManager, nearbyManager: NearbyManager, dataSource: DataSource) {
        self.usersManager = usersManager
        self.nearbyManager = nearbyManager
        self.dataSource = dataSource
        self.chats = dataSource.fetchChats()
    }
    
    func getChat(withUser userID: String) -> Chat? {
        if let chat = chats.first(where: { $0.id == userID }) {
            return chat
            
        } else {
            guard let user = usersManager.getProfile(ofUser: userID) else { return nil }
            
            let chat = Chat(withUser: user)
            dataSource.appendChat(chat)
            
            chats = dataSource.fetchChats()
            
            return chat
        }
    }
    
    func didReceive(message messageData: MessageData, fromUser userID: String) {
        if let chat = chats.first(where: { $0.id == userID }) {
            let message = Message(data: messageData, chatID: chat.id, type: .incoming)
            
            DispatchQueue.main.async {
                chat.add(message: message)
            }
            
        } else {
            guard let user = usersManager.getProfile(ofUser: userID) else { return }
            
            let chat = Chat(withUser: user)
            let message = Message(data: messageData, chatID: chat.id, type: .incoming)
            chat.add(message: message)
            
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                
                dataSource.appendChat(chat)
                chats = dataSource.fetchChats()
            }
        }
    }
}
