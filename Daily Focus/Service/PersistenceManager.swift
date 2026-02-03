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
        
        // First, try to decode as new format
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([FocusTask].self, from: data)
        } catch let newFormatError {
            // If that fails, try to migrate from old format
            print("Unable to decode tasks in new format, attempting migration: \(newFormatError)")
            return migrateOldFormat(data: data)
        }
    }
    
    private func migrateOldFormat(data: Data) -> [FocusTask] {
        // Try to decode as old format (without priority, isCarriedOver, createdAt)
        struct OldFocusTask: Codable {
            var title: String
            var isCompleted: Bool
        }
        
        do {
            let decoder = JSONDecoder()
            let oldTasks = try decoder.decode([OldFocusTask].self, from: data)
            print("Successfully migrated \(oldTasks.count) tasks from old format")
            
            // Migrate to new format
            let migratedTasks = oldTasks.map { oldTask in
                FocusTask(
                    title: oldTask.title,
                    isCompleted: oldTask.isCompleted,
                    priority: TaskPriority.medium,
                    isCarriedOver: false
                )
            }
            // Save migrated tasks
            save(tasks: migratedTasks)
            return migratedTasks
        } catch let migrationError {
            print("Migration failed: \(migrationError)")
            // If migration fails, return empty array to prevent crash
            // User can start fresh
            UserDefaults.standard.removeObject(forKey: tasksKey)
            return []
        }
    }
}
