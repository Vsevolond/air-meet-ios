import Foundation

// MARK: - Messages Chat

final class MessagesChat: ObservableObject {
    
    // MARK: - Internal Properties
    
    let id: String
    
    @Published var messages: [MessageItem] = []
    
    // MARK: - Initializers
    
    init(id: String) { self.id = id }
    
    // MARK: - Internal Methods
    
    func add(message messageObject: MessageObject, type messageType: MessageItem.MessageItemType) {
        let item = MessageItem(message: messageObject, type: messageType)
        messages.append(item)
    }
}

// MARK: - Extensions

extension MessagesChat: Equatable {
    
    static func == (lhs: MessagesChat, rhs: MessagesChat) -> Bool { lhs.id == rhs.id }
}

extension MessagesChat: Hashable {
    
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
