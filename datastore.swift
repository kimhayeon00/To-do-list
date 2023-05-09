//
//  datastore.swift
//  To do list
//
//  Created by 김하연 on 2023/05/10.
//

import Foundation
import SwiftUI
import Combine

struct Task : Identifiable {
    var id = String()
    var newTask = String()
    
}

class TaskStore : ObservableObject {
    @Published var tasks = [Task] ()
}

