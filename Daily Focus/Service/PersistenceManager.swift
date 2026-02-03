import Foundation

class PersistenceManager: PersistenceManagerProtocol {
    static let shared = PersistenceManager()
    private let tasksKey = "userTasks"
    
    private init() {} // Singleton
    
    func save(tasks: [FocusTask]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(tasks)
            UserDefaults.standard.set(data, forKey: tasksKey)
        } catch {
            print("Unable to encode tasks: \(error)")
        }
    }
    
    func load() -> [FocusTask] {
        guard let data = UserDefaults.standard.data(forKey: tasksKey) else { return [] }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([FocusTask].self, from: data)
        } catch {
            print("Unable to decode tasks: \(error)")
            return []
        }
    }
}
