import SwiftUI
import PhotosUI

// MARK: - Chat View

struct ChatView: View {
    
    // MARK: - Private Properties
    
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var inputText: String = ""
    @State private var isProfilePresented: Bool = false
    @State private var isImagePickerPresented: Bool = false
    @State private var keyboardHeight: CGFloat = 0
    
    // MARK: - Internal Properties
    
    @Bindable var chat: Chat
    let nearbyManager: NearbyManager
    
    @ObservationIgnored let dataSource: DataSource
    
    // MARK: - View Body
    
    var body: some View {
        VStack {
            ScrollViewReader { scrollView in
                List(chat.messages.sorted(by: { $0.date < $1.date }), id: \.id) { message in
                    MessageView(message: message)
                        .listRowSeparator(.hidden)
                        .transition(.slide)
                        .animation(.snappy, value: chat.messages)
                }
                .listStyle(.plain)
                .if(colorScheme == .dark, then: { $0.background(.black) }, else: { $0.background(.white) })
                .onTapGesture {
                    hideKeyboard()
                }
                .onAppear {
                    if let lastMessage = chat.lastMessage {
                        scrollView.scrollTo(lastMessage.id, anchor: .bottom)
                    }
                }
                .onChange(of: chat.messages) {
                    if let lastMessage = chat.lastMessage {
                        scrollView.scrollTo(lastMessage.id, anchor: .bottom)
                    }
                }
            }
            
            HStack(alignment: .bottom) {
                TextField(Constants.textFieldKey, text: $inputText, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .frame(minHeight: 30)
                    .padding(.leading, 10)
                
                Button(action: {
                    if inputText.isEmpty {
                        isImagePickerPresented.toggle()
                        
                    } else {
                        guard let data = MessageData(text: inputText) else { return }
                        
                        send(message: data)
                        inputText = ""
                    }
                    
                }, label: {
                    ZStack(alignment: .center) {
                        if inputText.isEmpty {
                            Image(systemName: Constants.chooseMediaImage)
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.gray)
                            
                        } else {
                            Circle().fill(.blue)
                            
                            Image(systemName: Constants.sendImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 20)
                                .foregroundStyle(.white)
                        }
                    }
                    .frame(height: 26)
                    .animation(.snappy(duration: 0.2), value: inputText.isEmpty)
                    .padding(.trailing, 10)
                })
            }
            .padding(.top, 10)
            .padding(.bottom, keyboardHeight > 0 ? keyboardHeight : 40)
            .background(.ultraThinMaterial)
        }
        .sheet(isPresented: $isImagePickerPresented, content: {
            ImagePicker(isPresented: $isImagePickerPresented) { result in
                processSelection(result)
            }
        })
        .toolbar {
            let user = chat.user
            
            ToolbarItem(placement: .principal) {
                Button(action: {
                    isProfilePresented.toggle()
                    
                }, label: {
                    Text(user.fullName)
                        .bold()
                        .foregroundColor(light: .black, dark: .white)
                })
            }
            
            if let image = user.image {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        isProfilePresented.toggle()
                        
                    }, label: {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .clipShape(.circle)
                    })
                    .frame(height: 50)
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .ignoresSafeArea(edges: .bottom)
        .keyboardHeight($keyboardHeight)
        .navigationDestination(isPresented: $isProfilePresented) {
            ProfileView(profile: chat.user, type: .common)
        }
    }
    
    private func processSelection(_ result: PHPickerResult) {
        let _ = result.itemProvider.loadDataRepresentation(for: .image) { data, _ in
            guard let data, let image = UIImage(data: data), let data = MessageData(image: image) else { return }
            
            DispatchQueue.main.async { send(message: data) }
        }
    }
    
    private func send(message messageData: MessageData) {
        let message = Message(data: messageData, chatID: chat.id, type: .outcoming)
        chat.add(message: message)
        
        guard let data = try? JSONEncoder().encode(messageData) else { return }
        let object = TransferObject(context: .message, data: data)
        
        nearbyManager.send(object: object, toUser: chat.id)
    }

    private func MessageView(message: Message) -> some View {
        HStack {
            if message.type == .outcoming {
                if message.data.type == .text {
                    Spacer().frame(minWidth: 40)
                    
                } else {
                    Spacer().frame(width: 40)
                }
            }
            
            if let text = message.data.value as? String {
                TextMessageView(text: text, type: message.type)
                    .layoutPriority(1)
                
            } else if let image = message.data.value as? UIImage {
                ImageMessageView(image: image)
                    .layoutPriority(1)
                
            } else {
                ErrorMessageView()
            }
            
            if message.type == .incoming {
                Spacer().frame(width: 40)
            }
        }
    }
    
    private func TextMessageView(text: String, type: Message.MessageType) -> some View {
        Text(text)
            .font(.callout)
            .bold()
            .padding(10)
            .if(type == .incoming, then: { view in
                view
                    .foregroundColor(light: .black, dark: .white)
                    .background(.thinMaterial)
            }, else: { view in
                view
                    .foregroundStyle(.white)
                    .background(.blue)
            })
            .clipShape(.rect(cornerRadius: 10))
    }
    
    private func ImageMessageView(image: UIImage) -> some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .clipShape(.rect(cornerRadius: 10))
    }
    
    private func ErrorMessageView() -> some View {
        Text("!")
            .font(.callout)
            .bold()
            .padding(10)
            .background(.red)
            .clipShape(.capsule)
    }
}

private enum Constants {
    
    static let textFieldKey: String = "Сообщение"
    
    static let chooseMediaImage: String = "paperclip"
    static let sendImage: String = "arrow.up"
}
