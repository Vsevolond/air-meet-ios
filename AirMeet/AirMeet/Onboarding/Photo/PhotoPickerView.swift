import SwiftUI
import PhotosUI

struct PhotoPickerView: View {
    
    @ObservedObject var profile: UserProfile
    @Binding var isPresented: Bool
    
    @Environment(\.viewController) private var viewController: UIViewController?
    @State private var isPickerPresented: Bool = false
    @State private var editingImage: UIImage? = nil
    
    var body: some View {
        ZStack {
            VStack {
                if let image = profile.image {
                    UserImage(image)
                        .padding(.top)
                    
                } else {
                    MockImage
                        .padding(.top)
                }
                
                Spacer()
                
                Button(action: {
                    isPresented.toggle()
                    
                }, label: {
                    Text(Constants.addButtonTitle)
                        .frame(width: .screenWidth * 0.75)
                        .font(.system(size: 18))
                        .bold()
                        .padding(10)
                        .foregroundStyle(.white)
                        .if(profile.image == nil, then: { view in
                            view.background(.gray.secondary)
                        }, else: { view in
                            view.background(.blue)
                        })
                        .clipShape(.rect(cornerRadius: 10))
                        .padding(.bottom, 20)
                })
                .disabled(profile.image == nil)
            }
        }
        .sheet(isPresented: $isPickerPresented, content: {
            ImagePicker(isPresented: $isPickerPresented) { result in
                processSelection(result)
            }
        })
        .onChange(of: editingImage, {
            viewController?.present(style: .fullScreen, transitionStyle: .crossDissolve, builder: {
                PhotoEditorView(image: $editingImage) { image in
                    profile.image = image
                }
                .ignoresSafeArea()
            })
        })
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Constants.navigationTitle)
    }
    
    private func UserImage(_ image: UIImage) -> some View {
        Button(action: {
            isPickerPresented.toggle()
            
        }, label: {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: .screenWidth * 0.8, height: .screenWidth * 0.8)
                .clipShape(.circle)
        })
    }
    
    private var MockImage: some View {
        Button(action: {
            isPickerPresented.toggle()
            
        }, label: {
            ZStack {
                Circle()
                    .stroke(.gray.secondary)
                    .fill(.thinMaterial)
                
                Image(systemName: Constants.mockImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: Constants.plusImageSize, height: Constants.plusImageSize)
                    .foregroundStyle(.blue)
            }
            .frame(width: .screenWidth * 0.8, height: .screenWidth * 0.8)
        })
        
    }
    
    private func processSelection(_ result: PHPickerResult) {
        let _ = result.itemProvider.loadDataRepresentation(for: .image) { data, _ in
            guard let data, let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                editingImage = image
            }
        }
    }
}

private enum Constants {
    
    static let navigationTitle: String = "Фото"
    static let mockImageName: String = "plus"
    
    static let plusImageSize: CGFloat = 30
    static let addButtonTitle: String = "Добавить"
}
