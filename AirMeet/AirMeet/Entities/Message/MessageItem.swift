import Foundation

// MARK: - Message Item

struct MessageItem: Hashable {
    
    // MARK: - Type Properties
    
    enum MessageItemType: Hashable {
        
        case incoming, outcoming
    }
    
    // MARK: - Internal Properties
    
    let message: MessageObject
    let type: MessageItemType
    let date: Date
    
    // MARK: - Initializers
    
    init(message: MessageObject, type: MessageItemType, date: Date = .now) {
        self.message = message
        self.type = type
        self.date = date
    }
}
