import Foundation
import SwiftData

// MARK: - User

@Model
final class User: Codable {
    
    // MARK: - Type Properties
    
    private enum CodingKeys: String, CodingKey {
        
        case id, name, surname, birthdate
    }
    
    // MARK: - Internal Properties
    
    @Attribute(.unique) let id: String
    
    var name: String
    var surname: String
    var birthdate: Date
    
    @Transient var age: Int {
        Calendar.current.dateComponents([.year], from: birthdate, to: .now).year ?? .zero
    }
    
    @Transient var ageString: String {
        switch age {
        case let x where [0, 5, 6, 7, 8, 9].contains(x % 10) || (11...14).contains(x): "\(age) лет"
        case let x where x % 10 == 1: "\(age) год"
        case let x where (2...4).contains(x % 10): "\(age) года"
        default: "\(age) лет"
        }
    }
    
    @Transient var birthdateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .init(identifier: "ru")
        dateFormatter.dateFormat = "dd MMM YYYY"
        
        return dateFormatter.string(from: birthdate)
    }
    
    @Transient var fullName: String { "\(name) \(surname)"}
    
    // MARK: - Initializers
    
    init(id: String, name: String, surname: String, birthdate: Date) {
        self.id = id
        self.name = name
        self.surname = surname
        self.birthdate = birthdate
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.surname = try container.decode(String.self, forKey: .surname)
        self.birthdate = try container.decode(Date.self, forKey: .birthdate)
    }
    
    // MARK: - Internal Methods
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(surname, forKey: .surname)
        try container.encode(birthdate, forKey: .birthdate)
    }
}
