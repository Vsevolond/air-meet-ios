import SwiftUI

struct HobbiesView: View {
    
    @Bindable var profile: UserProfile
    @Binding var isPresented: Bool
    var isOnboarding: Bool
    
    @State private var isPhotoPickerPresented: Bool = false
    
    var body: some View {
        VStack {
            List {
                Section {
                    FlexibleGrid(data: CreativityHobbie.allCases, spacing: 12, alignment: .leading) { hobbie in
                        HobbieItem(hobbie.title, isSelected: profile.hobbies.contains(.creativity(hobbie)))
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
                        HobbieItem(hobbie.title, isSelected: profile.hobbies.contains(.activeLifestyle(hobbie)))
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
                        HobbieItem(hobbie.title, isSelected: profile.hobbies.contains(.foodAndDrinks(hobbie)))
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
                        HobbieItem(hobbie.title, isSelected: profile.hobbies.contains(.socialLife(hobbie)))
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
                        HobbieItem(hobbie.title, isSelected: profile.hobbies.contains(.filmsAndSerials(hobbie)))
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
                        HobbieItem(hobbie.title, isSelected: profile.hobbies.contains(.music(hobbie)))
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
                        HobbieItem(hobbie.title, isSelected: profile.hobbies.contains(.homeTime(hobbie)))
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
                        HobbieItem(hobbie.title, isSelected: profile.hobbies.contains(.sport(hobbie)))
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
            
            if isOnboarding {
                Button(action: {
                    isPhotoPickerPresented.toggle()
                    
                }, label: {
                    Text(Constants.buttonTitle)
                        .frame(width: .screenWidth * 0.75)
                        .font(.system(size: 18))
                        .bold()
                        .padding(10)
                        .foregroundStyle(.white)
                        .if(profile.hobbies.isEmpty, then: { view in
                            view.background(.gray.secondary)
                        }, else: { view in
                            view.background(.blue)
                        })
                        .clipShape(.rect(cornerRadius: 10))
                        .padding(.bottom, 10)
                })
                .disabled(profile.hobbies.isEmpty)
                .navigationDestination(isPresented: $isPhotoPickerPresented) {
                    PhotoPickerView(profile: profile, isPresented: $isPresented)
                }
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
                    Text("Выбрано \(profile.hobbies.count) из \(Constants.hobbiesCountRange.upperBound)")
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
        if let index = profile.hobbies.firstIndex(of: hobbie) {
            profile.hobbies.remove(at: index)
            
        } else if Constants.hobbiesCountRange.contains(profile.hobbies.count) {
            profile.hobbies.append(hobbie)
        }
    }
}

private enum Constants {
    
    static let navigationTitle: String = "Интересы"
    static let hobbiesCountRange: ClosedRange<Int> = (0...10)
    
    static let buttonTitle: String = "Добавить"
}
