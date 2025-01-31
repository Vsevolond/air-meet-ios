import SwiftUI
import SwiftData
import Lottie

// MARK: - Meet View

struct MeetView: View {
    
    // MARK: - Private Properties
    
    @Environment(\.viewController) private var viewController: UIViewController?
    @State private var profile: UserProfile = .init(id: .deviceIdentifier ?? .uuid)
    @State private var animationMode: LottiePlaybackMode = .paused
    @State private var isOnboardingPresented: Bool = false
    
    // MARK: - Internal Properties
    
    let container: ModelContainer
    
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
                DetailsView(profile: profile, isPresented: $isOnboardingPresented)
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
            ProfileSaver.shared.saveProfile(profile)
            
            let mainViewController = MainContainer.build(with: profile, container: container)
            viewController?.present(style: .overFullScreen, transitionStyle: .crossDissolve, viewController: mainViewController)
        }
    }
}

// MARK: - Constants

private enum Constants {
    
    static let navigationTitle: String = "AirMeet"
    static let animationName: String = "meet-animation"
    
    static let buttonTitle: String = "Создать профиль"
}
