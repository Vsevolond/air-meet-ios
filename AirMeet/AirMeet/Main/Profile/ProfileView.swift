import SwiftUI

// MARK: - Profile View

struct ProfileView: View {
    
    // MARK: - Internal Properties
    
    @ObservedObject var account: Account
    
    // MARK: - Private Properties
    
    @Environment(\.viewController) private var viewController: UIViewController?
    
    // MARK: - View Body
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            List {
                ZStack(alignment: .bottomLeading) {
                    GeometryReader { proxy in
                        let minY = proxy.frame(in: .global).minY
                        let width = UIScreen.main.bounds.width
                        let offset = minY > 0 ? -minY : 0
                        
                        Image(uiImage: account.image ?? .init())
                            .resizable()
                            .offset(x: offset / 2, y: offset)
                            .frame(width: width - offset, height: width - offset)
                    }
                    .frame(width: .screenWidth, height: .screenWidth)
                    
                    VStack(alignment: .leading) {
                        Text(account.fullName)
                            .font(.system(size: 20))
                            .bold()
                            .foregroundStyle(.white)
                        
                        Text("• \(account.ageString)")
                            .font(.system(size: 16))
                            .foregroundStyle(.white)
                    }
                    .padding(.bottom, 20)
                    .padding(.leading, 10)
                }
                
                FlexibleGrid(data: account.hobbies, spacing: 10, alignment: .leading) { hobbie in
                    Text(hobbie.title)
                        .font(.system(size: 12))
                        .bold()
                        .padding(6)
                        .background(.thinMaterial)
                        .clipShape(.capsule)
                }
                .listRowSeparator(.hidden)
                
                Section {
                    ForEach(ProfileSettings.allCases, id: \.rawValue) { setting in
                        HStack {
                            Image(systemName: setting.imageName)
                                .padding(1)
                                .foregroundStyle(.white)
                                .background(setting.imageColor)
                                .clipShape(.rect(cornerRadius: 5))
                                .padding(.trailing, 5)
                            
                            Text(setting.title)
                                .font(.system(size: 16))
                                .bold()
                        }
                        .padding(5)
                    }
                } header: {
                    Text(Constants.settingsTitle)
                }
            }
            .listStyle(.plain)
            
            Button(action: {
                viewController?.present(style: .overFullScreen, transitionStyle: .crossDissolve, builder: {
                    ProfileEditorView(account: account)
                })
                
            }, label: {
                Text(Constants.changeTitle)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(.ultraThinMaterial, in: .capsule)
            })
            .padding(.top, 60)
            .padding(.trailing, 10)

        }
        .ignoresSafeArea()
    }
}

// MARK: - Constants

private enum Constants {
    
    static let settingsTitle: String = "Настройки"
    static let changeTitle: String = "Изм."
}


