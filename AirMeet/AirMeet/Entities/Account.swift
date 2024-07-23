import SwiftUI

// MARK: - Account

final class Account: Codable, ObservableObject {
    
    // MARK: - Type Properties
    
    private enum CodingKeys: String, CodingKey {
        
        case name, surname, birthdate, hobbies
    }
    
    // MARK: - Internal Properties
    
    @Published var name: String
    @Published var surname: String
    @Published var birthdate: Date
    @Published var hobbies: [Hobbie]
    @Published var image: UIImage?
    
    var age: Int {
        Calendar.current.dateComponents([.year], from: birthdate, to: .now).year ?? .zero
    }
    
    var ageString: String {
        switch age {
        case let x where [0, 5, 6, 7, 8, 9].contains(x % 10) || (11...14).contains(x): "\(age) лет"
        case let x where x % 10 == 1: "\(age) год"
        case let x where (2...4).contains(x % 10): "\(age) года"
        default: "\(age) лет"
        }
    }
    
    var birthdateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .init(identifier: "ru")
        dateFormatter.dateFormat = "dd MMM YYYY"
        
        return dateFormatter.string(from: birthdate)
    }
    
    var fullName: String { "\(name) \(surname)"}
    
    var discoveryInfo: AccountInfo { .init(name: name, surname: surname, age: age) }
    
    // MARK: - Initializers
    
    init(name: String = "", surname: String = "", birthdate: Date = .now, hobbies: [Hobbie] = [], image: UIImage? = nil) {
        self.name = name
        self.surname = surname
        self.birthdate = birthdate
        self.hobbies = hobbies
        self.image = image
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        self.surname = try container.decode(String.self, forKey: .surname)
        self.birthdate = try container.decode(Date.self, forKey: .birthdate)
        self.hobbies = try container.decode([String].self, forKey: .hobbies).compactMap { Hobbie(from: $0) }
    }
    
    // MARK: - Internal Methods
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(surname, forKey: .surname)
        try container.encode(birthdate, forKey: .birthdate)
        try container.encode(hobbies.map { $0.title }, forKey: .hobbies)
    }
}
