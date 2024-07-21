import SwiftUI

struct SettingsView: View {
    @ObservedObject private var account: Account
    
    init(account: Account) {
        self.account = account
    }
    
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
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                    
                    Text(account.fullName)
                        .foregroundStyle(Color.appColor(.white))
                        .font(.system(size: 20))
                        .bold()
                        .padding(.bottom, 20)
                        .padding(.leading, 10)
                }
                
                FlexibleGrid(data: account.hobbies, spacing: 10, alignment: .leading) { hobbie in
                    Text(hobbie.title)
                        .font(.system(size: 12))
                        .bold()
                        .padding(6)
                        .background(Color.appColor(.gray))
                        .clipShape(.capsule)
                }
                .listRowSeparator(.hidden)
                
                ForEach(Setting.allCases, id: \.rawValue) { setting in
                    HStack {
                        Image(systemName: setting.imageName)
                            .padding(1)
                            .foregroundStyle(Color.appColor(.white))
                            .background(setting.imageColor)
                            .clipShape(.rect(cornerRadius: 5))
                            .padding(.trailing)
                        
                        Text(setting.title)
                            .font(.system(size: 16))
                            .bold()
                    }
                    .padding(5)
                    .background(Color.appColor(.white))
                }
                
            }
            .listStyle(.plain)
            
            Button("Изм.") {
                // edit profile action
            }
            .foregroundStyle(Color.appColor(.white))
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(.ultraThinMaterial, in: .capsule)
            .shadow(radius: 5)
            .padding(.top, 20)
            .padding(.trailing, 20)
        }
        .ignoresSafeArea()
        .statusBar(hidden: true)
        .background(Color.appColor(.gray))
    }
}


