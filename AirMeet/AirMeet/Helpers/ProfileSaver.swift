import UIKit

// MARK: - Profile Saver Protocol

protocol ProfileSaverProtocol {
    
    func saveProfile(_ profile: UserProfile)
    func getProfile() -> UserProfile?
}

// MARK: - Profile Saver

final class ProfileSaver {
    
    static let shared: ProfileSaverProtocol = ProfileSaver()
    
    private init() {}
    
    // MARK: - Private Methods
    
    private func saveImage(_ image: UIImage) {
        guard let data = image.pngData() else { return }
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = path.appending(path: String.profileImageName)
        
        if FileManager.default.fileExists(atPath: url.absoluteString) {
            try? FileManager.default.removeItem(at: url)
        }
        
        try? data.write(to: url)
    }
    
    private func getImage() -> UIImage? {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = path.appending(path: String.profileImageName)
        
        guard let data = try? Data(contentsOf: url),
              let image = UIImage(data: data)
        else { return .none }
        
        return image
    }
}

// MARK: - Extensions

extension ProfileSaver: ProfileSaverProtocol {
    
    func saveProfile(_ profile: UserProfile) {
        guard let encoded = try? JSONEncoder().encode(profile) else { return }
        UserDefaults.standard.set(encoded, forKey: .profileKey)
        
        if let image = profile.image {
            saveImage(image)
        }
    }
    
    func getProfile() -> UserProfile? {
        guard let data = UserDefaults.standard.object(forKey: .profileKey) as? Data,
              let profile = try? JSONDecoder().decode(UserProfile.self, from: data)
        else {
            return nil
        }
        
        profile.image = getImage()
        return profile
    }
}
