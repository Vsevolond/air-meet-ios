import UIKit
import SwiftUI

// MARK: - Setting

enum Setting: String, CaseIterable {
    
    case notificationsAndSounds
    case dataAndStorage
    case decoration
    case language
    
    var title: String {
        switch self {
        case .notificationsAndSounds: "Уведомления и звуки"
        case .dataAndStorage: "Данные и память"
        case .decoration: "Оформление"
        case .language: "Язык"
        }
    }
    
    var imageName: String {
        switch self {
        case .notificationsAndSounds: "bell.badge.fill"
        case .dataAndStorage: "square.stack.3d.up.fill"
        case .decoration: "circle.lefthalf.filled"
        case .language: "globe"
        }
    }
    
    var imageColor: Color {
        switch self {
        case .notificationsAndSounds: Color(#colorLiteral(red: 0.939425528, green: 0.2556335926, blue: 0.175477773, alpha: 1))
        case .dataAndStorage: Color(#colorLiteral(red: 0.1503005028, green: 0.7958047986, blue: 0.3145685792, alpha: 1))
        case .decoration: Color(#colorLiteral(red: 0.1393350363, green: 0.6884083152, blue: 0.8982715011, alpha: 1))
        case .language: Color(#colorLiteral(red: 0.643112421, green: 0.3499975801, blue: 0.8834339976, alpha: 1))
        }
    }
}
