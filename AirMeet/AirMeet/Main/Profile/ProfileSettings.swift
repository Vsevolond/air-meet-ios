import UIKit
import SwiftUI

// MARK: - ProfileSettings

enum ProfileSettings: String, CaseIterable {
    
    case notificationsAndSounds
    case dataAndStorage
    
    var title: String {
        switch self {
        case .notificationsAndSounds: "Уведомления и звуки"
        case .dataAndStorage: "Данные и память"
        }
    }
    
    var imageName: String {
        switch self {
        case .notificationsAndSounds: "bell.badge.fill"
        case .dataAndStorage: "square.stack.3d.up.fill"
        }
    }
    
    var imageColor: Color {
        switch self {
        case .notificationsAndSounds: .red
        case .dataAndStorage: .green
        }
    }
}
