import Foundation

enum TaskPriority: String, Codable, CaseIterable {
    case high = "High Priority"
    case low = "Low Priority"
    case medium = "Medium Priority"
}

struct FocusTask: Codable {
    var title: String
    var isCompleted: Bool
    var priority: TaskPriority
    var isCarriedOver: Bool
    var createdAt: Date
    
    init(title: String, isCompleted: Bool = false, priority: TaskPriority = .medium, isCarriedOver: Bool = false) {
        self.title = title
        self.isCompleted = isCompleted
        self.priority = priority
        self.isCarriedOver = isCarriedOver
        self.createdAt = Date()
    }
}
