import SwiftUI

struct SearchView: View {
    
    @ObservedObject var model: SearchModel
    
    @State private var selectedUser: UserProfile? = nil
    
    private let columns: [GridItem] = [
        .init(.fixed(.screenWidth / 2)),
        .init(.fixed(.screenWidth / 2))
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(model.nearbyUsers, id: \.id) { user in
                        NearbyUserView(user: user)
                            .transition(.slide)
                            .animation(.snappy, value: model.nearbyUsers)
                    }
                }
            }
            .navigationDestination(item: $selectedUser, destination: { user in
                ProfileView(profile: user, type: .forNearbyUser)
            })
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(Constants.navigationTitle)
        }
        .tint(.white)
        .toolbar {
            Text(Constants.navigationTitle)
                .bold()
        }
        .onAppear {
            guard !model.isSearching else { return }
            model.startSearching()
        }
    }
    
    private func NearbyUserView(user: UserProfile) -> some View {
        Button(action: {
            selectedUser = user
            
        }, label: {
            VStack {
                if let image = user.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: .screenWidth * 0.25, height: .screenWidth * 0.25)
                        .clipShape(.circle)
                    
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .foregroundStyle(.gray)
                        .frame(width: .screenWidth * 0.25, height: .screenWidth * 0.25)
                        .background(.white)
                        .clipShape(.circle)
                }
                
                Text(user.fullName)
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(light: .black, dark: .white)
            }
        })
    }
}

private enum Constants {
    
    static let navigationTitle: String = "Поиск"
}
