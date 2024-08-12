import SwiftUI
import PhotosUI

struct ChatView: View {
    
    let user: UserProfile
    @ObservedObject var chat: MessagesChat
    @ObservedObject var model: ChatsModel
    
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var inputText: String = ""
    @State private var isProfilePresented: Bool = false
    @State private var isImagePickerPresented: Bool = false
    @State private var keyboardHeight: CGFloat = 0
    
    init(userID: String, model: ChatsModel) {
        self.model = model
        
        self.user = model.getProfile(ofUser: userID)
        self.chat = model.getChat(withUser: userID)
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(chat.messages, id: \.self) { messageObject in
                    MessageView(object: messageObject.message, type: messageObject.type)
                        .listRowSeparator(.hidden)
                        .transition(.slide)
                        .animation(.snappy, value: chat.messages)
                }
            }
            .listStyle(.plain)
            .if(colorScheme == .dark, then: { $0.background(.black) }, else: { $0.background(.white) })
            .onTapGesture {
                hideKeyboard()
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
                        guard let object = MessageObject(text: inputText) else { return }
                        model.send(message: object, toUser: user.id)
                        
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
        .ignoresSafeArea(edges: .bottom)
        .keyboardHeight($keyboardHeight)
        .navigationDestination(isPresented: $isProfilePresented) {
            ProfileView(profile: user, type: .common)
        }
        .onAppear {
            NotificationCenter.default.post(name: .hideTabBarKey, object: nil)
        }
        .onDisappear {
            NotificationCenter.default.post(name: .showTabBarKey, object: nil)
        }
    }
    
    private func processSelection(_ result: PHPickerResult) {
        let _ = result.itemProvider.loadDataRepresentation(for: .image) { data, _ in
            guard let data, let image = UIImage(data: data), let object = MessageObject(image: image) else { return }
            
            DispatchQueue.main.async {
                model.send(message: object, toUser: user.id)
            }
        }
    }
    
    private func MessageView(object: MessageObject, type: MessageItem.MessageItemType) -> some View {
        HStack {
            if type == .outcoming {
                if object.type == .text {
                    Spacer().frame(minWidth: 40)
                    
                } else {
                    Spacer().frame(width: 40)
                }
            }
            
            if object.type == .text, let text = String(data: object.data, encoding: .utf8) {
                TextMessageView(text: text, type: type)
                
            } else if object.type == .image, let image = UIImage(data: object.data) {
                ImageMessageView(image: image)
                
            } else {
                ErrorMessageView()
            }
            
            if type == .incoming {
                Spacer().frame(width: 40)
            }
        }
    }
    
    private func TextMessageView(text: String, type: MessageItem.MessageItemType) -> some View {
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
