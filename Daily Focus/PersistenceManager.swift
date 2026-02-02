import Foundation

struct PersistenceManager {
    static let tasksKey = "userTasks"
    
    // save array to disk
    static func save(tasks: [FocusTask]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(tasks)
            UserDefaults.standard.set(data, forKey: tasksKey)
        } catch {
            print("Unable to encode tasks: \(error)")
        }
    }
    
    // load array from disk
    static func load() -> [FocusTask] {
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
