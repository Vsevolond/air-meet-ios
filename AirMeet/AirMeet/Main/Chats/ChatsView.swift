import SwiftUI
import Combine

struct ChatsView: View {
    
    @ObservedObject var model: ChatsModel
    
    @Environment(\.colorScheme) private var colorScheme
    @State private var selectedUser: String?
    @State private var cancellables = Set<AnyCancellable>()
    
    init(model: ChatsModel) {
        self.model = model
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(Array(model.chats), id: \.key) { userID, chat in
                    let profile = model.getProfile(ofUser: userID)
                    
                    Button(action: {
                        selectedUser = userID
                        
                    }, label: {
                        HStack(alignment: .top) {
                            if let image = profile.image {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50)
                                    .clipShape(.circle)
                                
                            } else {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .scaledToFill()
                                    .foregroundStyle(.gray)
                                    .frame(width: 50, height: 50)
                                    .background(.white)
                                    .clipShape(.circle)
                            }
                            
                            Text(profile.fullName)
                                .font(.callout)
                                .bold()
                                .foregroundColor(light: .black, dark: .white)
                        }
                    })
                }
            }
            .listStyle(.plain)
            .navigationTitle(Constants.navigationTitle)
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(item: $selectedUser, destination: { userID in
                ChatView(userID: userID, model: model)
            })
        }
        .if(colorScheme == .dark, then: { $0.tint(.white) }, else: { $0.tint(.black) })
        .onAppear {
            NotificationCenter.default.publisher(for: .openChatKey)
                .receive(on: DispatchQueue.main)
                .compactMap { $0.object as? String }
                .sink(receiveValue: { selectedUser = $0 })
                .store(in: &cancellables)
        }
    }
}

// MARK: - Constants

private enum Constants {
    
    static let navigationTitle: String = "Чаты"
}
