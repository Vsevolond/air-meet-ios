import SwiftUI

// MARK: - Straight Trapezoid

private struct StraightTrapezoid: Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))

        return path
    }
}

// MARK: - Details View

struct DetailsView: View {
    
    // MARK: - Type Properties
    
    private enum Field {
        
        case name, surname
    }

    // MARK: - Internal Properties
    
    @ObservedObject var account: Account
    @Binding var isPresented: Bool
    
    // MARK: - Private Properties
    
    @FocusState private var focusedField: Field?
    @State private var isFieldsEmpty: Bool = true
    
    // MARK: - View Body
    
    var body: some View {
        ScrollView {
            Group {
                StraightTrapezoid()
                    .foregroundStyle(.blue)
                    .frame(width: .screenWidth, height: .screenWidth)
                
                InputTextField(Constants.nameTitle, text: $account.name)
                    .padding(.horizontal)
                    .padding(.top)
                    .submitLabel(.next)
                    .focused($focusedField, equals: .name)
                    .textContentType(.givenName)
                    .onChange(of: account.name) {
                        checkIsEmpty()
                    }
                
                InputTextField(Constants.surnameTitle, text: $account.surname)
                    .padding(.horizontal)
                    .padding(.bottom)
                    .submitLabel(.done)
                    .focused($focusedField, equals: .surname)
                    .textContentType(.familyName)
                    .onChange(of: account.surname) {
                        checkIsEmpty()
                    }
                
                DatePicker(Constants.birthdateTitle, selection: $account.birthdate, in: ...Date(), displayedComponents: .date)
                    .bold()
                    .environment(\.locale, Constants.locale)
                    .padding(.horizontal, 10)
                    .padding(.bottom)
                    .submitLabel(.done)
                
                Divider()
            }
            .offset(y: -.screenWidth * 0.5)
            
            Spacer()
            
            NavigationLink {
                HobbiesView(account: account, isPresented: $isPresented, isOnboarding: true)
                
            } label: {
                Text(Constants.buttonTitle)
                    .frame(width: .screenWidth * 0.75)
                    .font(.system(size: 18))
                    .bold()
                    .padding(10)
                    .foregroundStyle(.white)
                    .if(isFieldsEmpty, then: { view in
                        view.background(.gray.secondary)
                    }, else: { view in
                        view.background(.blue)
                    })
                    .clipShape(.rect(cornerRadius: 10))
            }
            .disabled(isFieldsEmpty)
        }
        .onSubmit {
            switch focusedField {
                
            case .name:
                focusedField = .surname
                
            default:
                hideKeyboard()
            }
        }
        .navigationTitle(Constants.navigationTitle)
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Private Methods
    
    private func InputTextField(_ title: String, text: Binding<String>) -> some View {
        TextField(title, text: text)
            .bold()
            .padding(10)
            .background(.thinMaterial)
            .clipShape(.capsule)
            .autocorrectionDisabled()
    }
    
    private func checkIsEmpty() {
        guard !account.name.isEmpty, !account.surname.isEmpty else {
            isFieldsEmpty = true
            return
        }
        
        isFieldsEmpty = false
    }
}

// MARK: - Constants

private enum Constants {
    
    static let nameTitle: String = "Имя"
    static let surnameTitle: String = "Фамилия"
    static let birthdateTitle: String = "Дата рождения"
    
    static let navigationTitle: String = "О себе"
    
    static let buttonImage: String = "arrowshape.turn.up.forward.fill"
    static let buttonTitle: String = "Далее"
    
    static let locale: Locale = .init(identifier: "ru")
}
