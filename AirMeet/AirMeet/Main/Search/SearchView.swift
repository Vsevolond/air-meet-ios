import SwiftUI

struct SearchView: View {
    
    @ObservedObject var model: SearchModel
    
    private let columns: [GridItem] = [
        .init(.fixed(.screenWidth / 2)),
        .init(.fixed(.screenWidth / 2))
    ]
    
    var body: some View {
        VStack {
            Text(Constants.title)
                .font(.headline)
                .bold()
            
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(model.nearbyUsers, id: \.id) { user in
                        NearbyUserView(user: user)
                            .transition(.slide)
                            .animation(.snappy, value: model.nearbyUsers)
                    }
                }
            }
        }
        .onAppear {
            guard !model.isSearching else { return }
            model.startSearching()
        }
    }
    
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
                    .clipShape(.circle)
            }
            
            Text(user.fullName)
        }
    }
}

private enum Constants {
    
    static let title: String = "Поиск"
}
