import Foundation
import SwiftData

final class DataSource {
    
    private let container: ModelContainer
    private let context: ModelContext

    @MainActor
    init(container: ModelContainer) {
        self.container = container
        self.context = container.mainContext
    }
    
    func fetchChats() -> [Chat] {
        do {
            let descriptor = FetchDescriptor<Chat>(sortBy: [SortDescriptor<Chat>(\.lastDate, order: .reverse)])
            return try context.fetch(descriptor)
            
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func appendChat(_ chat: Chat) {
        context.insert(chat)
        
        do {
            try context.save()
            
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func removeChat(_ chat: Chat) {
        context.delete(chat)
        
        do {
            try context.save()
            
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func removeMessage(_ message: Message) {
        context.delete(message)
        
        do {
            try context.save()
            
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
