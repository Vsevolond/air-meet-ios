import UIKit
import SwiftData

// MARK: - Initializers

@Model
final class Message {
    
    // MARK: - Type Properties
    
    enum MessageType: Codable {
        
        case incoming, outcoming
    }
    
    // MARK: - Internal Properties
    
    @Attribute(.unique) let id: UUID
    @Relationship(deleteRule: .cascade) let data: MessageData
    
    let chatID: String
    let date: Date
    let type: MessageType
    
    // MARK: - Initializers
    
    init(data: MessageData, chatID: String, date: Date = .now, type: MessageType) {
        self.id = data.id
        self.data = data
        self.chatID = chatID
        self.date = date
        self.type = type
    }
}

// MARK: - Message Data

@Model
final class MessageData: Codable {
    
    // MARK: - Type Properties
    
    private enum CodingKeys: String, CodingKey {
        
        case data, type
    }
    
    enum MessageDataType: Int, Codable {
        
        case text, image
    }
    
    // MARK: - Internal Properties
    
    @Attribute(.unique) let id: UUID
    let data: Data
    let type: MessageDataType
    
    @Transient var value: Any? {
        switch type {
        case .text: return String(data: data, encoding: .utf8)
        case .image: return UIImage(data: data)
        }
    }
    
    // MARK: - Initializers
    
    private init(data: Data, type: MessageDataType) {
        self.id = UUID()
        self.data = data
        self.type = type
    }
    
    convenience init?(text: String) {
        guard let data = text.data(using: .utf8) else { return nil }
        self.init(data: data, type: .text)
    }
    
    convenience init?(image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.2) else { return nil }
        self.init(data: data, type: .image)
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.data = try container.decode(Data.self, forKey: .data)
        let typeValue = try container.decode(Int.self, forKey: .type)
        
        if typeValue == 0 {
            self.type = .text
            
        } else {
            self.type = .image
        }
        
        self.id = UUID()
    }
    
    // MARK: - Internal Methods
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(data, forKey: .data)
        try container.encode(type.rawValue, forKey: .type)
    }
}
