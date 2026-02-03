import Foundation
@testable import Daily_Focus

class MockPersistenceManager: PersistenceManagerProtocol {
    var savedTasks: [FocusTask] = []
    var loadCalled = false
    
    func save(tasks: [FocusTask]) {
        savedTasks = tasks
    }
    
    func load() -> [FocusTask] {
        loadCalled = true
        return savedTasks
    }
}
