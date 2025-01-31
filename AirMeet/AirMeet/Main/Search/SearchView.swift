import SwiftUI

// MARK: - Search View

struct SearchView: View {
    
    // MARK: - Internal Properties
    
    @ObservedObject var model: SearchModel
    
    // MARK: - Private Properties
    
    private let columns: [GridItem] = [
        .init(.fixed(.screenWidth / 2)),
        .init(.fixed(.screenWidth / 2))
    ]
    
    // MARK: - View Body
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(model.nearbyUsers, id: \.self) { userID in
                        if let profile = model.profile(ofUser: userID) {
                            
                            NavigationLink {
                                ProfileView(profile: profile, type: .forNearbyUser)
                                
                            } label: {
                                NearbyUserView(user: profile)
                                    .transition(.slide)
                                    .animation(.snappy, value: model.nearbyUsers)
                            }
                        }
                    }
                }
            }
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
    
    // MARK: - Private Methods
    
    private func NearbyUserView(user: UserProfile) -> some View {
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
    }
}

// MARK: - Constants

private enum Constants {
    
    static let navigationTitle: String = "Поиск"
}
