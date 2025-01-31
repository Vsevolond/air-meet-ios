import Foundation

// MARK: - Hobbie Protocol

protocol HobbieProtocol: Hashable, Codable {
    
    var title: String { get }
    init?(from string: String)
}

protocol HobbieTypeProtocol {
    
    static var typename: String { get }
}

// MARK: - Hobbie

enum Hobbie: HobbieProtocol {
    
    var title: String {
        switch self {
            
        case .creativity(let hobbie): return hobbie.title
        case .activeLifestyle(let hobbie): return hobbie.title
        case .foodAndDrinks(let hobbie): return hobbie.title
        case .socialLife(let hobbie): return hobbie.title
        case .filmsAndSerials(let hobbie): return hobbie.title
        case .music(let hobbie): return hobbie.title
        case .homeTime(let hobbie): return hobbie.title
        case .sport(let hobbie): return hobbie.title
        case .unknown: return ""
        }
    }
    
    init?(from string: String) {
        if let creativity = CreativityHobbie(from: string) {
            self = .creativity(creativity)
            
        } else if let activeLifestyle = ActiveLifestyleHobbie(from: string) {
            self = .activeLifestyle(activeLifestyle)
            
        } else if let foodAndDrinks = FoodAndDrinksHobbie(from: string) {
            self = .foodAndDrinks(foodAndDrinks)
            
        } else if let socialLife = SocialLifeHobbie(from: string) {
            self = .socialLife(socialLife)
            
        } else if let filmsAndSerials = FilmsAndSerialsHobbie(from: string) {
            self = .filmsAndSerials(filmsAndSerials)
            
        } else if let music = MusicHobbie(from: string) {
            self = .music(music)
            
        } else if let homeTime = HomeTimeHobbie(from: string) {
            self = .homeTime(homeTime)
            
        } else if let sport = SportHobbie(from: string) {
            self = .sport(sport)
            
        } else {
            self = .unknown
        }
    }
    
    case creativity(_ hobbie: CreativityHobbie)
    case activeLifestyle(_ Hobbie: ActiveLifestyleHobbie)
    case foodAndDrinks(_ hobbie: FoodAndDrinksHobbie)
    case socialLife(_ hobbie: SocialLifeHobbie)
    case filmsAndSerials(_ hobbie: FilmsAndSerialsHobbie)
    case music(_ hobbie: MusicHobbie)
    case homeTime(_ hobbie: HomeTimeHobbie)
    case sport(_ hobbie: SportHobbie)
    case unknown
}

// MARK: - CreativityHobbie

enum CreativityHobbie: String, CaseIterable, HobbieProtocol, HobbieTypeProtocol {
    
    static var typename: String { "Искусство" }
    
    var title: String { self.rawValue }
    
    init?(from string: String) { self.init(rawValue: string) }
    
    case photography = "📷 Фотография"
    case filming = "📹 Видеосъёмка"
    case design = "🖌️ Дизайн"
    case handiwork = "🧵 Рукоделие"
    case dancing = "🕺 Танцы"
    case singing = "🗣️ Пение"
    case music = "🎼 Музыка"
    case painting = "🧑‍🎨 Рисование"
}

// MARK: - ActiveLifestyleHobbie

enum ActiveLifestyleHobbie: String, CaseIterable, HobbieProtocol, HobbieTypeProtocol {
    
    static var typename: String { "Активный образ жизни" }
    
    var title: String { self.rawValue }
    
    init?(from string: String) { self.init(rawValue: string) }
    
    case running = "🏃 Бег"
    case fitness = "💪 Фитнес"
    case cycling = "🚲 Велосипед"
    case jockey = "🏇 Верховая езда"
    case ski = "🎿 Лыжи"
    case yoga = "🧘 Йога"
    case snowboard = "🏂 Сноуборд"
    case rollerSkate = "🛼 Ролики"
    case skateboard = "🛹 Скейтборд"
    case bowling = "🎳 Боулинг"
}

// MARK: - FoodAndDrinksHobbie

enum FoodAndDrinksHobbie: String, CaseIterable, HobbieProtocol, HobbieTypeProtocol {
    
    static var typename: String { "Еда и напитки" }
    
    var title: String { self.rawValue }
    
    init?(from string: String) { self.init(rawValue: string) }
    
    case pizza = "🍕 Пицца"
    case sushi = "🍣 Суши"
    case burgers = "🍔 Бургеры"
    case healthy = "🥦 Здоровое питание"
    case veganism = "🥗 Веганство"
    case vegetarianism = "🥑 Вегетарианство"
    case coffee = "☕️ Кофе"
    case tea = "🫖 Чай"
    case bakery = "🥧 Выпечка"
    case sweets = "🍫 Сладости"
    case homeCooking = "🥟 Домашняя кухня"
}

// MARK: - SocialLifeHobbie

enum SocialLifeHobbie: String, CaseIterable, HobbieProtocol, HobbieTypeProtocol {
    
    static var typename: String { "Социальная жизнь" }
    
    var title: String { self.rawValue }
    
    init?(from string: String) { self.init(rawValue: string) }
    
    case cinema = "🍿 Кинотеатры"
    case concerts = "🎆 Концерты и шоу"
    case museumsAndGalleries = "🏛️ Музеи и галереи"
    case theaters = "🎭 Театры"
    case camping = "🏕️ Отдых на природе"
    case festivals = "🎡 Фестивали"
    case hangouts = "🪩 Тусовки и клубы"
    case volunteering = "🫴 Волонтёрство"
    case restaurants = "🍽️ Рестораны"
    case journeys = "✈️ Путешествия"
    case shopping = "🛍️ Шопинг"
    case meetings = "🤝 Встречи с друзьями"
    case art = "🖼️ Искусство"
    case activeRest = "🎯 Активный отдых"
    case tours = "📍 Экскурсии"
    case beachRest = "🏖️ Пляжный отдых"
    case hunting = "🎣 Охота и рыбалка"
    case cruise = "🛳️ Круизы"
    case mountains = "⛰️ Горы"
    case events = "🎟️ Мероприятия и концерты"
}

// MARK: - FilmsAndSerialsHobbie

enum FilmsAndSerialsHobbie: String, CaseIterable, HobbieProtocol, HobbieTypeProtocol {
    
    static var typename: String { "Фильмы и сериалы" }
    
    var title: String { self.rawValue }
    
    init?(from string: String) { self.init(rawValue: string) }
    
    case comedies = "😂 Комедии"
    case cartoons = "🎈 Мультфильмы"
    case historical = "🗿 Исторические"
    case detectives = "🕵️ Детективы"
    case adventures = "🚂 Приключения"
    case horrors = "👻 Ужасы"
    case dramas = "🥹 Драмы"
    case melodramas = "🫶 Мелодрамы"
    case trillers = "🔫 Триллеры"
    case fighters = "💥 Боевики"
}

// MARK: - MusicHobbie

enum MusicHobbie: String, CaseIterable, HobbieProtocol, HobbieTypeProtocol {
    
    static var typename: String { "Музыка" }
    
    var title: String { self.rawValue }
    
    init?(from string: String) { self.init(rawValue: string) }
    
    case popMusic = "🍭 Поп-музыка"
    case hipHop = "💎 Хип-хоп"
    case electronics = "🎼 Электроника"
    case rock = "🎸 Рок"
    case rap = "🎤 Рэп"
    case classical = "🎻 Классическая музыка"
    case metal = "⛓️ Метал"
    case techno = "🎹 Техно"
    case blues = "🎷 Блюз"
    case meloman = "🎧 Меломан"
}

// MARK: - HomeTimeHobbie

enum HomeTimeHobbie: String, CaseIterable, HobbieProtocol, HobbieTypeProtocol {
    
    static var typename: String { "Время дома" }
    
    var title: String { self.rawValue }
    
    init?(from string: String) { self.init(rawValue: string) }
    
    case computerGames = "🕹️ Компьютерные игры"
    case cooking = "🧑‍🍳 Кулинария"
    case tableGames = "🎲 Настольные игры"
    case cinema = "🎬 Кино и сериалы"
    case gardening = "🪴 Садоводство"
    case fashion = "👜 Мода и красота"
    case books = "📖 Книги"
    case technologies = "🤖 IT и технологии"
    case automobiles = "🚗 Автомобили"
}

// MARK: - SportHobbie

enum SportHobbie: String, CaseIterable, HobbieProtocol, HobbieTypeProtocol {
    
    static var typename: String { "Спорт" }
    
    var title: String { self.rawValue }
    
    init?(from string: String) { self.init(rawValue: string) }
    
    case football = "⚽️ Футбол"
    case swimming = "🏊 Плавание"
    case cycling = "🚴 Велоспорт"
    case volleyball = "🏐 Волейбол"
    case basketball = "🏀 Баскетбол"
    case hockey = "🏒 Хоккей"
    case athletics = "🥏 Лёгкая атлетика"
    case wightlifting = "🏋️ Тяжелая атлетика"
    case boxing = "🥊 Бокс"
    case iceSkate = "⛸️ Фигурное катание"
    case gymnastics = "🤸‍♂️ Гимнастика"
    case billiard = "🎱 Бильярд"
    case bigTennis = "🎾 Большой теннис"
    case tableTennis = "🏓 Настольный теннис"
    case diving = "🤿 Дайвинг"
    case wrestling = "🤼‍♂️ Борьба"
    case fencing = "🤺 Фехтование"
    case surfing = "🏄 Сёрфинг"
    case climbing = "🧗 Скалолазание"
    case chess = "♟️ Шахматы"
    case gaming = "🎮 Киберспорт"
}
