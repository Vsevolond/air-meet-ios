import UIKit

// MARK: - Message

struct MessageObject: Codable, Hashable {
    
    // MARK: - Type Properties
    
    enum MessageDataType: Codable, Hashable {
        
        case text, image
    }
    
    // MARK: - Internal Properties
    
    let data: Data
    let type: MessageDataType
    
    var value: Any? {
        switch type {
        case .text: return String(data: data, encoding: .utf8)
        case .image: return UIImage(data: data)
        }
    }
    
    // MARK: - Initializers
    
    private init(data: Data, type: MessageDataType) {
        self.data = data
        self.type = type
    }
    
    init?(text: String) {
        guard let data = text.data(using: .utf8) else { return nil }
        self.init(data: data, type: .text)
    }
    
    init?(image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.5) else { return nil }
        self.init(data: data, type: .image)
    }
}
