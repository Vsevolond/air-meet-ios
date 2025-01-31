import SwiftUI
import PhotosUI

// MARK: - Profile Editor View

struct ProfileEditorView: View {
    
    // MARK: - Internal Properties
    
    @Bindable var profile: UserProfile
    
    // MARK: - Private Properties
    
    @Environment(\.viewController) private var viewController: UIViewController?
    @State private var isImagePickerPresented: Bool = false
    @State private var editingImage: UIImage? = nil
    @State private var isDatePickerPresented: Bool = false
    @State private var isHobbiesPickerPresented: Bool = false
    
    // MARK: - View Body
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ImageHeaderView
                }
                .listRowInsets(.zero)
                .listRowBackground(Color.clear)
                
                Section {
                    TextField(Constants.nameTitle, text: $profile.name)
                        .bold()
                        .submitLabel(.done)
                    
                    TextField(Constants.surnameTitle, text: $profile.surname)
                        .bold()
                        .submitLabel(.done)
                }
                .listRowBackground(
                    Rectangle()
                        .fill(.thinMaterial)
                )
                
                Section {
                    DatePickerView
                }
                .listRowBackground(
                    Rectangle()
                        .fill(.thinMaterial)
                )
                
                Section {
                    HobbiesGridView
                    
                } header: {
                    HobbiesHeaderView
                        .padding(.vertical)
                }
                .listRowInsets(.zero)
                .listRowBackground(Color.clear)
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .navigationTitle(Constants.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(Constants.doneTitle) {
                        
                        ProfileSaver.shared.saveProfile(profile)
                        viewController?.dismiss(animated: true)
                    }
                    .bold()
                }
            }
        }
        .background(.background)
        .sheet(isPresented: $isImagePickerPresented, content: {
            ImagePicker(isPresented: $isImagePickerPresented) { result in
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
        .onSubmit {
            hideKeyboard()
        }
    }
    
    // MARK: - Private Views
    
    private var ImageHeaderView: some View {
        HStack {
            Spacer()
            
            Button(action: {
                isImagePickerPresented.toggle()
                
            }, label: {
                Image(uiImage: profile.image ?? .init())
                    .resizable()
                    .scaledToFill()
                    .frame(width: .screenWidth * 0.5, height: .screenWidth * 0.5)
                    .clipShape(.circle)
            })
            .buttonStyle(.plain)
            
            Spacer()
        }
    }
    
    private var DatePickerView: some View {
        VStack {
            Button(action: {
                isDatePickerPresented.toggle()
                
            }, label: {
                HStack {
                    Text(Constants.birthdateTitle)
                        .bold()
                        .foregroundColor(light: .black, dark: .white)
                    
                    Spacer()
                    
                    Text(profile.birthdateString)
                        .bold()
                        .if(isDatePickerPresented, then: { text in
                            text.foregroundStyle(.blue)
                        }, else: { text in
                            text.foregroundStyle(.gray)
                        })
                }
            })
            
            if isDatePickerPresented {
                DatePicker(Constants.birthdateTitle, selection: $profile.birthdate, in: ...Date(), displayedComponents: .date)
                    .bold()
                    .environment(\.locale, Constants.locale)
                    .datePickerStyle(.wheel)
            }
        }
    }
    
    private var HobbiesGridView: some View {
        FlexibleGrid(data: profile.hobbies, spacing: 10, alignment: .leading) { hobbie in
            Text(hobbie.title)
                .font(.system(size: 12))
                .bold()
                .padding(8)
                .background(.thinMaterial)
                .clipShape(.capsule)
        }
    }
    
    private var HobbiesHeaderView: some View {
        HStack {
            Text(Constants.hobbiesTitle)
                .font(.system(size: 14))
                .bold()
            
            Spacer()
            
            Button(Constants.changeHobbiesTitle) {
                isHobbiesPickerPresented.toggle()
            }
            .font(.system(size: 14))
            .bold()
            .navigationDestination(isPresented: $isHobbiesPickerPresented) {
                HobbiesView(profile: profile, isPresented: $isHobbiesPickerPresented, isOnboarding: false)
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func processSelection(_ result: PHPickerResult) {
        let _ = result.itemProvider.loadDataRepresentation(for: .image) { data, _ in
            guard let data, let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                editingImage = image
            }
        }
    }
}

// MARK: - Constants

private enum Constants {
    
    static let navigationTitle: String = "Профиль"
    static let doneTitle: String = "Готово"
    
    static let nameTitle: String = "Имя"
    static let surnameTitle: String = "Фамилия"
    static let birthdateTitle: String = "Дата рождения"
    
    static let locale: Locale = .init(identifier: "ru")
    
    static let hobbiesTitle: String = "Интересы"
    static let changeHobbiesTitle: String = "Изменить"
}
