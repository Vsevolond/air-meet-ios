import UIKit

struct AccountInfo {
    
    private enum Keys: String {
        
        case name, surname, age
    }
    
    let name: String
    let surname: String
    let age: Int
    
    var fullName: String { "\(name) \(surname)"}
    
    var ageString: String {
        switch age {
        case let x where [0, 5, 6, 7, 8, 9].contains(x % 10) || (11...14).contains(x): "\(age) лет"
        case let x where x % 10 == 1: "\(age) год"
        case let x where (2...4).contains(x % 10): "\(age) года"
        default: "\(age) лет"
        }
    }
    
    var dict: [String: String] {
        [
            Keys.name.rawValue : name,
            Keys.surname.rawValue : surname,
            Keys.age.rawValue : "\(age)"
        ]
    }
    
    init(name: String, surname: String, age: Int) {
        self.name = name
        self.surname = surname
        self.age = age
    }
    
    init?(dict: [String: String]) {
        guard let name = dict[Keys.name.rawValue],
              let surname = dict[Keys.surname.rawValue],
              let ageString = dict[Keys.age.rawValue]
        else {
            return nil
        }
        
        self.name = name
        self.surname = surname
        self.age = Int(ageString) ?? .zero
    }
}
