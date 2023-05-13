//
//  datastore.swift
//  To do list
//
//  Created by 김하연 on 2023/05/10.
//

import Foundation
import SwiftUI
import Combine

//struct Task : Identifiable {
//    var id = String()
//    var newTask = String()
//
//}
struct Task: Identifiable {
    let id: String
    let newTask: String
    var completed: Bool // 완료 여부를 표시하기 위한 속성

    init(id: String, newTask: String, completed: Bool = false) {
        self.id = id
        self.newTask = newTask
        self.completed = completed
    }
}

class TaskStore: ObservableObject {
    @Published var tasks = [Task]()
    
    func toggleTaskCompletion(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].completed.toggle()
        }
    }
}

