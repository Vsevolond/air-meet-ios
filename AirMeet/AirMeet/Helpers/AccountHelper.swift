import UIKit

// MARK: - Account Helper Protocol

protocol AccountHelperProtocol {
    
    func saveImage(_ image: UIImage)
    func getImage() -> UIImage?
}

// MARK: - Account Helper

final class AccountHelper: AccountHelperProtocol {
    
    static let shared: AccountHelperProtocol = AccountHelper()
    
    private init() {}
    
    func saveImage(_ image: UIImage) {
        guard let data = image.pngData() else { return }
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = path.appending(path: String.accountImageName)
        
        if FileManager.default.fileExists(atPath: url.absoluteString) {
            try? FileManager.default.removeItem(at: url)
        }
        
        try? data.write(to: url)
    }
    
    func getImage() -> UIImage? {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = path.appending(path: String.accountImageName)
        
        guard let data = try? Data(contentsOf: url),
              let image = UIImage(data: data)
        else { return .none }
        
        return image
    }
}
