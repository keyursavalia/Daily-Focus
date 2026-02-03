import Foundation
import Combine

class TaskViewModel {
    // MARK: - Published Properties
    @Published private(set) var tasks: [FocusTask] = []
    
    // MARK: - Constants
    private let maxTaskLimit = 3
    private let persistenceManager: PersistenceManagerProtocol
    private let shouldAddDefaultTask: Bool
    
    // MARK: - Initialization
    init(persistenceManager: PersistenceManagerProtocol = PersistenceManager.shared, shouldAddDefaultTask: Bool = true) {
        self.persistenceManager = persistenceManager
        self.shouldAddDefaultTask = shouldAddDefaultTask
        loadTasks()
    }
    
    // MARK: - Public Methods
    
    /// Loads tasks from persistence
    func loadTasks() {
        tasks = persistenceManager.load()
        
        // Default task for first-time users
        if tasks.isEmpty && shouldAddDefaultTask {
            tasks = [FocusTask(title: "Tap to complete", isCompleted: false)]
            saveTasks()
        }
    }
    
    /// Adds a new task if under the limit
    /// - Parameter title: The task title
    /// - Returns: Result indicating success or failure with reason
    func addTask(title: String) -> Result<Void, TaskError> {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            return .failure(.emptyTitle)
        }
        
        guard tasks.count < maxTaskLimit else {
            return .failure(.limitReached)
        }
        
        let newTask = FocusTask(title: title, isCompleted: false)
        tasks.append(newTask)
        saveTasks()
        
        return .success(())
    }
    
    /// Toggles the completion status of a task
    /// - Parameter index: The index of the task
    func toggleTaskCompletion(at index: Int) {
        guard index < tasks.count else { return }
        tasks[index].isCompleted.toggle()
        saveTasks()
    }
    
    /// Deletes a task at the given index
    /// - Parameter index: The index of the task
    func deleteTask(at index: Int) {
        guard index < tasks.count else { return }
        tasks.remove(at: index)
        saveTasks()
    }
    
    /// Gets the task at a specific index
    /// - Parameter index: The index of the task
    /// - Returns: The task if index is valid
    func task(at index: Int) -> FocusTask? {
        guard index < tasks.count else { return nil }
        return tasks[index]
    }
    
    /// Returns the number of tasks
    var taskCount: Int {
        return tasks.count
    }
    
    // MARK: - Private Methods
    
    private func saveTasks() {
        persistenceManager.save(tasks: tasks)
    }
}
