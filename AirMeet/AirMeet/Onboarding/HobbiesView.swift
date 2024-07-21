import SwiftUI

struct HobbiesView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    @ObservedObject var account: Account
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            List {
                Section {
                    FlexibleGrid(data: CreativityHobbie.allCases, spacing: 12, alignment: .leading) { hobbie in
                        HobbieItem(hobbie.title, isSelected: account.hobbies.contains(.creativity(hobbie)))
                            .onTapGesture {
                                toggleHobbie(.creativity(hobbie))
                            }
                    }
                } header: {
                    SectionHeader(CreativityHobbie.typename)
                }
                .listSectionSeparator(.hidden, edges: .top)
                
                Section {
                    FlexibleGrid(data: ActiveLifestyleHobbie.allCases, spacing: 12, alignment: .leading) { hobbie in
                        HobbieItem(hobbie.title, isSelected: account.hobbies.contains(.activeLifestyle(hobbie)))
                            .onTapGesture {
                                toggleHobbie(.activeLifestyle(hobbie))
                            }
                    }
                } header: {
                    SectionHeader(ActiveLifestyleHobbie.typename)
                }
                .listSectionSeparator(.hidden, edges: .top)
                
                Section {
                    FlexibleGrid(data: FoodAndDrinksHobbie.allCases, spacing: 12, alignment: .leading) { hobbie in
                        HobbieItem(hobbie.title, isSelected: account.hobbies.contains(.foodAndDrinks(hobbie)))
                            .onTapGesture {
                                toggleHobbie(.foodAndDrinks(hobbie))
                            }
                    }
                } header: {
                    SectionHeader(FoodAndDrinksHobbie.typename)
                }
                .listSectionSeparator(.hidden, edges: .top)
                
                Section {
                    FlexibleGrid(data: SocialLifeHobbie.allCases, spacing: 12, alignment: .leading) { hobbie in
                        HobbieItem(hobbie.title, isSelected: account.hobbies.contains(.socialLife(hobbie)))
                            .onTapGesture {
                                toggleHobbie(.socialLife(hobbie))
                            }
                    }
                } header: {
                    SectionHeader(SocialLifeHobbie.typename)
                }
                .listSectionSeparator(.hidden, edges: .top)
                
                Section {
                    FlexibleGrid(data: FilmsAndSerialsHobbie.allCases, spacing: 12, alignment: .leading) { hobbie in
                        HobbieItem(hobbie.title, isSelected: account.hobbies.contains(.filmsAndSerials(hobbie)))
                            .onTapGesture {
                                toggleHobbie(.filmsAndSerials(hobbie))
                            }
                    }
                } header: {
                    SectionHeader(FilmsAndSerialsHobbie.typename)
                }
                .listSectionSeparator(.hidden, edges: .top)
                
                Section {
                    FlexibleGrid(data: MusicHobbie.allCases, spacing: 12, alignment: .leading) { hobbie in
                        HobbieItem(hobbie.title, isSelected: account.hobbies.contains(.music(hobbie)))
                            .onTapGesture {
                                toggleHobbie(.music(hobbie))
                            }
                    }
                } header: {
                    SectionHeader(MusicHobbie.typename)
                }
                .listSectionSeparator(.hidden, edges: .top)
                
                Section {
                    FlexibleGrid(data: HomeTimeHobbie.allCases, spacing: 12, alignment: .leading) { hobbie in
                        HobbieItem(hobbie.title, isSelected: account.hobbies.contains(.homeTime(hobbie)))
                            .onTapGesture {
                                toggleHobbie(.homeTime(hobbie))
                            }
                    }
                } header: {
                    SectionHeader(HomeTimeHobbie.typename)
                }
                .listSectionSeparator(.hidden, edges: .top)
                
                Section {
                    FlexibleGrid(data: SportHobbie.allCases, spacing: 12, alignment: .leading) { hobbie in
                        HobbieItem(hobbie.title, isSelected: account.hobbies.contains(.sport(hobbie)))
                            .onTapGesture {
                                toggleHobbie(.sport(hobbie))
                            }
                    }
                } header: {
                    SectionHeader(SportHobbie.typename)
                }
                .listSectionSeparator(.hidden, edges: .top)
            }
            .listStyle(.plain)
            
            NavigationLink {
                PhotoPickerView(account: account, isPresented: $isPresented)
                
            } label: {
                Text(account.hobbies.isEmpty ? Constants.notAddButtonTitle : Constants.addButtonTitle)
                    .frame(width: .screenWidth * 0.75)
                    .font(.system(size: 18))
                    .bold()
                    .padding(10)
                    .foregroundStyle(.white)
                    .if(account.hobbies.isEmpty, then: { view in
                        view.background(.gray.secondary)
                    }, else: { view in
                        view.background(.blue)
                    })
                    .clipShape(.rect(cornerRadius: 10))
                    .padding(.bottom, 10)
            }

        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Constants.navigationTitle)
        .toolbar(content: {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(Constants.navigationTitle)
                        .font(.system(size: 20))
                        .bold()
                    Text("Выбрано \(account.hobbies.count) из \(Constants.hobbiesCountLimit)")
                        .font(.system(size: 14))
                        .foregroundStyle(.blue)
                }
            }
        })
    }
    
    private func HobbieItem(_ text: String, isSelected: Bool) -> some View {
        Text(text)
            .font(.system(size: 12))
            .bold()
            .padding(8)
            .if(isSelected, then: { view in
                view
                    .background(.blue)
                    .foregroundStyle(.white)
                
            }, else: { view in
                view.background(.thinMaterial)
            })
            .clipShape(.capsule)
    }
    
    private func SectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 20))
            .bold()
            .foregroundColor(light: .black, dark: .white)
    }
    
    private func toggleHobbie(_ hobbie: Hobbie) {
        if let index = account.hobbies.firstIndex(of: hobbie) {
            account.hobbies.remove(at: index)
        } else if account.hobbies.count < Constants.hobbiesCountLimit {
            account.hobbies.append(hobbie)
        }
    }
}

private enum Constants {
    
    static let navigationTitle: String = "Интересы"
    static let hobbiesCountLimit: Int = 10
    
    static let notAddButtonTitle: String = "Не добавлять"
    static let addButtonTitle: String = "Добавить"
}
