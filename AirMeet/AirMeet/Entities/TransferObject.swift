import Foundation

// MARK: - Transfer Object

struct TransferObject: Codable {
    
    // MARK: - Type Properties
    
    enum TranferContext: Codable {
        
        case additionalInfo, message
    }
    
    // MARK: - Internal Properties
    
    let context: TranferContext
    let data: Data
}
