import XCTest
@testable import Daily_Focus

class PersistenceManagerTests: XCTestCase {
    var persistenceManager: PersistenceManager!
    let testKey = "testTasks"
    
    override func setUp() {
        super.setUp()
        persistenceManager = PersistenceManager.shared
        // Clear any existing data
        UserDefaults.standard.removeObject(forKey: "userTasks")
    }
    
    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: "userTasks")
        super.tearDown()
    }
    
    func testSaveAndLoad() {
        // Given
        let tasks = [
            FocusTask(title: "Task 1", isCompleted: false),
            FocusTask(title: "Task 2", isCompleted: true)
        ]
        
        // When
        persistenceManager.save(tasks: tasks)
        let loadedTasks = persistenceManager.load()
        
        // Then
        XCTAssertEqual(loadedTasks.count, 2)
        XCTAssertEqual(loadedTasks[0].title, "Task 1")
        XCTAssertEqual(loadedTasks[1].title, "Task 2")
        XCTAssertFalse(loadedTasks[0].isCompleted)
        XCTAssertTrue(loadedTasks[1].isCompleted)
    }
    
    func testLoadEmpty() {
        // When
        let tasks = persistenceManager.load()
        
        // Then
        XCTAssertTrue(tasks.isEmpty)
    }
}
