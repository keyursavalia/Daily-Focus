import Foundation

protocol PersistenceManagerProtocol {
    func save(tasks: [FocusTask])
    func load() -> [FocusTask]
}
