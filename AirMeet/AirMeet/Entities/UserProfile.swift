import SwiftUI

// MARK: - UserProfile

final class UserProfile: Codable, ObservableObject {
    
    // MARK: - Type Properties
    
    private enum ProfileCodingKeys: String, CodingKey {
        
        case id, name, surname, birthdate, hobbies
    }
    
    // MARK: - Additional Info
    
    struct AdditionalInfo: Codable {
        
        // MARK: - Type Properties
        
        private enum AdditionalCodingKeys: String, CodingKey {
            
            case hobbies, image
        }
        
        // MARK: - Internal Properties
        
        var hobbies: [Hobbie]
        var image: UIImage?
        
        // MARK: - Initializers
        
        init?(hobbies: [Hobbie], image: UIImage?) {
            guard let image, !hobbies.isEmpty else { return nil }
            
            self.hobbies = hobbies
            self.image = image
        }
        
        init(from decoder: any Decoder) throws {
            var container = try decoder.container(keyedBy: AdditionalCodingKeys.self)
            
            self.hobbies = try container.decode([String].self, forKey: .hobbies).compactMap { Hobbie(from: $0) }
            
            guard let imageData = try? container.decode(Data.self, forKey: .image) else { return }
            self.image = UIImage(data: imageData)
        }
        
        // MARK: - Internal Methods
        
        func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: AdditionalCodingKeys.self)
            
            try container.encode(hobbies.map { $0.title }, forKey: .hobbies)
            
            guard let image, let imageData = image.jpegData(compressionQuality: 0.5) else { return } // todo: static quality
            try container.encode(imageData, forKey: .image)
        }
    }
    
    // MARK: - Internal Properties
    
    let id: String
    
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
    
    var discoveryInfo: [String: String] {
        [
            ProfileCodingKeys.name.rawValue : name,
            ProfileCodingKeys.surname.rawValue : surname,
            ProfileCodingKeys.birthdate.rawValue : ISO8601DateFormatter().string(from: birthdate)
        ]
    }
    
    var additionalInfo: AdditionalInfo? { AdditionalInfo(hobbies: hobbies, image: image) }
    
    // MARK: - Initializers
    
    init(id: String, 
         name: String = "",
         surname: String = "",
         birthdate: Date = .now,
         hobbies: [Hobbie] = [],
         image: UIImage? = nil
    ) {
        self.id = id
        self.name = name
        self.surname = surname
        self.birthdate = birthdate
        self.hobbies = hobbies
        self.image = image
    }
    
    convenience init?(id: String, discoveryInfo info: [String: String]) {
        guard let name = info[ProfileCodingKeys.name.rawValue],
              let surname = info[ProfileCodingKeys.surname.rawValue],
              let birthdateString = info[ProfileCodingKeys.birthdate.rawValue],
              let birthdate = ISO8601DateFormatter().date(from: birthdateString)
        else {
            return nil
        }
        
        self.init(id: id, name: name, surname: surname, birthdate: birthdate)
    }
    
    init(from decoder: any Decoder) throws {
        var container = try decoder.container(keyedBy: ProfileCodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.surname = try container.decode(String.self, forKey: .surname)
        self.birthdate = try container.decode(Date.self, forKey: .birthdate)
        self.hobbies = try container.decode([String].self, forKey: .hobbies).compactMap { Hobbie(from: $0) }
    }
    
    // MARK: - Internal Methods
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: ProfileCodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(surname, forKey: .surname)
        try container.encode(birthdate, forKey: .birthdate)
        try container.encode(hobbies.map { $0.title }, forKey: .hobbies)
    }
    
    func addInfo(_ additionalInfo: AdditionalInfo) {
        self.hobbies = additionalInfo.hobbies
        self.image = additionalInfo.image
    }
}

// MARK: - Extensions

extension UserProfile: Equatable {
    
    static func == (lhs: UserProfile, rhs: UserProfile) -> Bool { lhs.id == rhs.id }
}

extension UserProfile: Hashable {
    
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
