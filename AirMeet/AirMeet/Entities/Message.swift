import Foundation

// MARK: - Message

struct Message: Codable {
    
    // MARK: - Internal Properties
    
    let value: String
    let sendingDate: Date
    var receivingDate: Date
    
    init(value: String, sendingDate: Date = .now, receivingDate: Date = .now) {
        self.value = value
        self.sendingDate = sendingDate
        self.receivingDate = receivingDate
    }
}
