import UIKit
import Combine

// MARK: - Account

final class Account: Codable {
    
    // MARK: - Type Properties
    
    private enum CodingKeys: String, CodingKey {
        
        case name
        case surname
        case age
        case hobbies
    }
    
    // MARK: - Private Properties
    
    private var isValid: Bool { !name.isEmpty && !surname.isEmpty }
    
    // MARK: - Internal Properties
    
    var validSubject: CurrentValueSubject<Bool, Never> = .init(false)
    
    var name: String { didSet { validSubject.send(isValid) } }
    var surname: String { didSet { validSubject.send(isValid) } }
    var age: Int
    var hobbies: [Hobbie]
    var image: UIImage?
    
    var fullName: String { "\(name) \(surname)"}
    
    // MARK: - Initializers
    
    init(name: String, surname: String, age: Int, hobbies: [Hobbie], image: UIImage? = nil) {
        self.name = name
        self.surname = surname
        self.age = age
        self.hobbies = hobbies
        self.image = image
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.surname = try container.decode(String.self, forKey: .surname)
        self.age = try container.decode(Int.self, forKey: .age)
        self.hobbies = try container.decode([String].self, forKey: .hobbies).compactMap { Hobbie(rawValue: $0) }
    }
    
    // MARK: - Internal Methods
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(surname, forKey: .surname)
        try container.encode(age, forKey: .age)
        try container.encode(hobbies, forKey: .hobbies)
    }
}
