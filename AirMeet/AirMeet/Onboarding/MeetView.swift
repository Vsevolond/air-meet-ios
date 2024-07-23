import SwiftUI
import Lottie

// MARK: - Meet View

struct MeetView: View {
    
    // MARK: - Private Properties
    
    @Environment(\.viewController) private var viewController: UIViewController?
    @StateObject private var account: Account = .init()
    @State private var animationMode: LottiePlaybackMode = .paused
    @State private var isOnboardingPresented: Bool = false
    
    // MARK: - View Body
    
    var body: some View {
        NavigationStack {
            LottieView(animation: .named(Constants.animationName))
                .playbackMode(animationMode)
            
            Spacer()
            
            Button(action: {
                isOnboardingPresented.toggle()
                
            }, label: {
                Text(Constants.buttonTitle)
                    .frame(width: .screenWidth * 0.75)
                    .font(.system(size: 18))
                    .bold()
                    .padding(.vertical, 10)
                    .foregroundStyle(.white)
                    .background(.blue)
                    .clipShape(.rect(cornerRadius: 10))
            })
            .padding(.bottom, 25)
            .navigationDestination(isPresented: $isOnboardingPresented) {
                DetailsView(account: account, isPresented: $isOnboardingPresented)
            }
        }
        .onAppear {
            animationMode = .playing(.fromProgress(0, toProgress: 1, loopMode: .loop))
        }
        .onDisappear {
            animationMode = .paused
        }
        .onChange(of: isOnboardingPresented) {
            guard !isOnboardingPresented else { return }
            saveAccount()
            
            let mainViewController = MainContainer.build(with: account)
            viewController?.present(style: .overFullScreen, transitionStyle: .crossDissolve, viewController: mainViewController)
        }
    }
    
    // MARK: - Private Methods
    
    private func saveAccount() {
        guard let image = account.image, let encoded = try? JSONEncoder().encode(account) else { return }
        
        DispatchQueue.global().async {
            AccountHelper.shared.saveImage(image)
        }
        
        UserDefaults.standard.set(encoded, forKey: .accountKey)
    }
}

// MARK: - Constants

private enum Constants {
    
    static let navigationTitle: String = "AirMeet"
    static let animationName: String = "meet-animation"
    
    static let buttonTitle: String = "Создать профиль"
}
