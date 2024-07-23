import SwiftUI
import PhotosUI

// MARK: - TODO
// - сохранение аккаунта только при изменении его свойств

// MARK: - Profile Editor View

struct ProfileEditorView: View {
    
    // MARK: - Internal Properties
    
    @ObservedObject var account: Account
    
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
                    TextField(Constants.nameTitle, text: $account.name)
                        .bold()
                        .submitLabel(.done)
                    
                    TextField(Constants.surnameTitle, text: $account.surname)
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
                        saveAccount()
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
                    account.image = image
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
                Image(uiImage: account.image ?? .init())
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
                    
                    Text(account.birthdateString)
                        .bold()
                        .if(isDatePickerPresented, then: { text in
                            text.foregroundStyle(.blue)
                        }, else: { text in
                            text.foregroundStyle(.gray)
                        })
                }
            })
            
            if isDatePickerPresented {
                DatePicker(Constants.birthdateTitle, selection: $account.birthdate, in: ...Date(), displayedComponents: .date)
                    .bold()
                    .environment(\.locale, Constants.locale)
                    .datePickerStyle(.wheel)
            }
        }
    }
    
    private var HobbiesGridView: some View {
        FlexibleGrid(data: account.hobbies, spacing: 10, alignment: .leading) { hobbie in
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
                HobbiesView(account: account, isPresented: $isHobbiesPickerPresented, isOnboarding: false)
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
    
    private func saveAccount() {
        guard let image = account.image, let encoded = try? JSONEncoder().encode(account) else { return }
        
        DispatchQueue.global().async {
            AccountHelper.shared.saveImage(image)
        }
        
        UserDefaults.standard.set(encoded, forKey: .accountKey)
    }
}

#Preview {
    ProfileEditorView(account: .init(name: "Всеволод", surname: "Донченко", birthdate: .now, hobbies: [.activeLifestyle(.bowling), .creativity(.dancing), .filmsAndSerials(.adventures), .foodAndDrinks(.bakery), .homeTime(.automobiles), .music(.blues), .socialLife(.activeRest), .sport(.athletics)], image: .test))
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