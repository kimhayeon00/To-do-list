import Foundation

class DataStore: ObservableObject {
    @Published var tasks: [Task] = []
    
    func toggleTaskCompletion(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].completed.toggle()
        }
    }
}

struct Task: Identifiable {
    let id: String
    let newTask: String
    var completed: Bool = false
    let dueDate: TaskPriority
}

enum TaskPriority: String, CaseIterable, Identifiable {
    case all = "All"
    case today = "Today"
    case tomorrow = "Tomorrow"
    case thisWeek = "This Week"
    case thisMonth = "This Month"
    case thisYear = "This Year"
    
    var id: String { self.rawValue }
    
    var description: String { self.rawValue }
}
