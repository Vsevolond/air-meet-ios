import Foundation
import SwiftData

// MARK: - Chat

@Model
final class Chat {
    
    @Attribute(.unique) let id: String
    @Relationship(deleteRule: .cascade) let user: UserProfile
    @Relationship(deleteRule: .cascade) var messages: [Message]
    
    var lastDate: Date
    
    @Transient var lastMessage: Message? { messages.last }
    
    // MARK: - Initializers
    
    init(withUser user: UserProfile, messages: [Message] = [], lastDate: Date = .now) {
        self.id = user.id
        self.user = user
        self.messages = messages
        self.lastDate = lastDate
    }
    
    // MARK: - Internal Methods
    
    func add(message: Message) {
        messages.append(message)
        lastDate = message.date
    }
}
