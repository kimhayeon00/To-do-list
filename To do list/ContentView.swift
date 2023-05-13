import SwiftUI

struct ContentView: View {
    @ObservedObject var taskStore = DataStore()
    @State var newTask: String = ""
    @State var selectedPriority: TaskPriority?
    
    var priorities: [TaskPriority] = [.all, .today, .tomorrow, .thisWeek, .thisMonth, .thisYear] // "All" 메뉴 추가
    
    var searchBar: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(priorities, id: \.self) { priority in
                        Button(action: {
                            self.selectedPriority = priority
                        }) {
                            Text(priority.description)
                                .foregroundColor(.white)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(priority == selectedPriority ? Color.blue : Color.gray)
                                .cornerRadius(20)
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            HStack {
                TextField("Insert New Task", text: self.$newTask)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Button(action: self.addTask) {
                    Text("Add New")
                }
                .padding(.horizontal)
            }
        }
    }
    
    func addTask() {
        guard let priority = selectedPriority else { return }
        
        let task = Task(id: UUID().uuidString, newTask: newTask, dueDate: priority)
        taskStore.tasks.append(task)
        self.newTask = ""
        
        // "All" 메뉴에서 작업을 추가한 경우 selectedPriority를 nil로 설정하여 모든 작업이 표시되도록 함
        if selectedPriority == .all {
            self.selectedPriority = nil
        }
    }
    
    var filteredTasks: [Task] {
        if selectedPriority == .all {
            return taskStore.tasks
        } else if let priority = selectedPriority {
            return taskStore.tasks.filter { $0.dueDate == priority }
        } else {
            return taskStore.tasks
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                searchBar.padding()
                List {
                    ForEach(filteredTasks) { task in
                        Text(task.newTask)
                            .strikethrough(task.completed)
                            .foregroundColor(task.completed ? Color.gray : Color.primary) // 줄이 그어지면서 글씨 색이 회색으로 변경
                            .onTapGesture {
                                taskStore.toggleTaskCompletion(task)
                            }
                    }
                    .onMove(perform: self.move)
                    .onDelete(perform: self.deleteTasks)
                }
                .navigationTitle("To Do List")
            }
            .navigationBarItems(trailing: EditButton())
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        taskStore.tasks.move(fromOffsets: source, toOffset: destination)
    }
    
    func deleteTasks(at offsets: IndexSet) {
        taskStore.tasks.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
