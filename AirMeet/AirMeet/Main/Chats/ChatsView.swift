import SwiftUI
import SwiftData
import Combine

// MARK: - Chats View

struct ChatsView: View {
    
    // MARK: - Private Properties
    
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var selectedUser: String?
    @State private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Internal Properties
    
    @ObservedObject var model: ChatsModel
    
    // MARK: - View Body
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(model.chats, id: \.id) { chat in
                    NavigationLink {
                        ChatView(chat: chat, nearbyManager: model.nearbyManager, dataSource: model.dataSource)
                        
                    } label: {
                        ChatRow(for: chat)
                    }
                }.onDelete(perform: { indexes in
                    for index in indexes {
                        model.deleteChat(index: index)
                    }
                })
            }
            .listStyle(.plain)
            .navigationTitle(Constants.navigationTitle)
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(item: $selectedUser) { userID in
                if let chat = model.getChat(withUser: userID) {
                    ChatView(chat: chat, nearbyManager: model.nearbyManager, dataSource: model.dataSource)
                    
                } else {
                    AnyView(Text("Что то пошло не так"))
                }
            }
        }
        .if(colorScheme == .dark, then: { $0.tint(.white) }, else: { $0.tint(.black) })
        .onReceive(NotificationCenter.default.publisher(for: .openChat), perform: { notification in
            guard let userID = notification.object as? String else { return }
            selectedUser = userID
        })
    }
    
    // MARK: - Private Methods
    
    @ViewBuilder
    private func ChatRow(for chat: Chat) -> some View {
        let user = chat.user
        
        HStack(alignment: .top) {
            
            if let image = user.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50)
                    .clipShape(.circle)
                
            } else {
                Image(systemName: Constants.mockImage)
                    .resizable()
                    .scaledToFill()
                    .foregroundStyle(.gray)
                    .frame(width: 50, height: 50)
                    .background(.white)
                    .clipShape(.circle)
            }
            
            Text(user.fullName)
                .font(.callout)
                .bold()
                .foregroundColor(light: .black, dark: .white)
        }
    }
}

// MARK: - Constants

private enum Constants {
    
    static let navigationTitle: String = "Чаты"
    static let mockImage: String = "person.crop.circle.fill"
}
