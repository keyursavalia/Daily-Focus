import XCTest
@testable import Daily_Focus

class TaskViewModelTests: XCTestCase {
    var viewModel: TaskViewModel!
    var mockPersistence: MockPersistenceManager!
    
    override func setUp() {
        super.setUp()
        mockPersistence = MockPersistenceManager()
        // Disable default task for testing
        viewModel = TaskViewModel(
            persistenceManager: mockPersistence,
            shouldAddDefaultTask: false
        )
    }
    
    override func tearDown() {
        viewModel = nil
        mockPersistence = nil
        super.tearDown()
    }
    
    func testAddTask_Success() {
        // Given
        XCTAssertEqual(viewModel.taskCount, 0) // Now truly empty
        let taskTitle = "Test Task"
        
        // When
        let result = viewModel.addTask(title: taskTitle)
        
        // Then
        switch result {
        case .success:
            XCTAssertEqual(viewModel.taskCount, 1)
            XCTAssertEqual(viewModel.task(at: 0)?.title, taskTitle)
        case .failure(let error):
            XCTFail("Expected success but got failure: \(error)")
        }
    }
    
    func testAddTask_LimitReached() {
        // Given - Add 3 tasks
        viewModel.addTask(title: "Task 1")
        viewModel.addTask(title: "Task 2")
        viewModel.addTask(title: "Task 3")
        
        // When - Try to add 4th task
        let result = viewModel.addTask(title: "Task 4")
        
        // Then
        switch result {
        case .success:
            XCTFail("Expected failure but got success")
        case .failure(let error):
            XCTAssertEqual(error, .limitReached)
            XCTAssertEqual(viewModel.taskCount, 3)
        }
    }
    
    func testAddTask_EmptyTitle() {
        // Given
        XCTAssertEqual(viewModel.taskCount, 0)
        
        // When
        let result = viewModel.addTask(title: "   ")
        
        // Then
        switch result {
        case .success:
            XCTFail("Expected failure but got success")
        case .failure(let error):
            XCTAssertEqual(error, .emptyTitle)
            XCTAssertEqual(viewModel.taskCount, 0)
        }
    }
    
    func testToggleTaskCompletion() {
        // Given
        viewModel.addTask(title: "Test Task")
        XCTAssertFalse(viewModel.task(at: 0)?.isCompleted ?? true)
        
        // When
        viewModel.toggleTaskCompletion(at: 0)
        
        // Then
        XCTAssertTrue(viewModel.task(at: 0)?.isCompleted ?? false)
    }
    
    func testDeleteTask() {
        // Given
        viewModel.addTask(title: "Task 1")
        viewModel.addTask(title: "Task 2")
        XCTAssertEqual(viewModel.taskCount, 2)
        
        // When
        viewModel.deleteTask(at: 0)
        
        // Then
        XCTAssertEqual(viewModel.taskCount, 1)
        XCTAssertEqual(viewModel.task(at: 0)?.title, "Task 2")
    }
    
    func testTaskCount() {
        // Given
        XCTAssertEqual(viewModel.taskCount, 0)
        
        // When
        viewModel.addTask(title: "Task 1")
        
        // Then
        XCTAssertEqual(viewModel.taskCount, 1)
    }
}
