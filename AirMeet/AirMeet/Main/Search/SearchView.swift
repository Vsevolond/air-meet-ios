import SwiftUI

private enum SectionType: String {
    
    case nearBy = "Рядом"
    case requests = "Запросы"
}

struct SearchView: View {
    
    @ObservedObject private var model: SearchModel
    @State private var currentSection: SectionType = .nearBy
    
    private let columns: [GridItem] = [
        .init(.fixed(.screenWidth / 2)),
        .init(.fixed(.screenWidth / 2))
    ]
    
    init(model: SearchModel) {
        self.model = model
    }
    
    private var TitleView: some View {
        Text("AirMeet")
            .font(.title)
            .bold()
            .foregroundLinearGradient(colors: [.appColor(.magenta), .appColor(.blue)], startPoint: .leading, endPoint: .trailing)
            .padding([.top, .leading], 10)
    }
    
    private var SwitchSectionView: some View {
        HStack {
            Button(action: {
                currentSection = .nearBy
                
            }, label: {
                VStack {
                    Text(SectionType.nearBy.rawValue)
                        .foregroundStyle(currentSection == .nearBy ? Color.appColor(.magenta) : Color.appColor(.gray))
                        .bold(currentSection == .nearBy)
                    
                    Capsule().fill(currentSection == .nearBy ? Color.appColor(.magenta) : Color.appColor(.gray))
                        .frame(height: 4)
                        .padding([.leading, .trailing], 30)
                }
            })
            
            Button(action: {
                currentSection = .requests
                
            }, label: {
                VStack {
                    Text(SectionType.requests.rawValue)
                        .foregroundStyle(currentSection == .requests ? Color.appColor(.blue) : Color.appColor(.gray))
                        .bold(currentSection == .requests)
                    
                    Capsule().fill(currentSection == .requests ? Color.appColor(.blue) : Color.appColor(.gray))
                        .frame(height: 4)
                        .padding([.leading, .trailing], 30)
                }
            })
        }
    }
    
    private func NearbyUserView(user: AccountInfo, id: String) -> some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.appColor(.gray), lineWidth: 1)
            
            HStack {
                ZStack(alignment: .center) {
                    UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 10)
                        .foregroundStyle(Color.appColor(.magenta))
                        .frame(width: .screenWidth / 10)
                    
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: .screenWidth / 16)
                        .foregroundStyle(Color.appColor(.white))
                }
                .padding(.trailing, 10)
                
                VStack {
                    Text(user.name)
                        .font(.system(size: 16))
                        .bold()
                        .lineLimit(1)
                    
                    Text(user.surname)
                        .font(.system(size: 16))
                        .bold()
                        .lineLimit(1)
                    
                    Text(user.ageString)
                        .font(.system(size: 12))
                        .foregroundStyle(Color.appColor(.cyan))
                        .lineLimit(1)
                }
                .padding(5)
                .layoutPriority(1)
            }
        }
        .contextMenu {
            Button {
                
            } label: {
                Label("Профиль", systemImage: "person.circle.fill")
            }

            Button {
                model.invite(userID: id)
                
            } label: {
                Label("Сообщение", systemImage: "message.fill")
            }
            
            Button {
                
            } label: {
                Label("Пригласить", systemImage: "person.fill.badge.plus")
            }

        }
        .padding(.horizontal, 15)
        .padding(.vertical, 5)
    }
    
    var body: some View {
        VStack {
            TitleView
            SwitchSectionView
            
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(Array(model.nearbyUsers), id: \.key) { id, user in
                        NearbyUserView(user: user, id: id)
                    }
                }
            }
        }
        .onAppear {
            guard !model.isSearchingStarted else { return }
            model.startSearching()
        }
    }
}
