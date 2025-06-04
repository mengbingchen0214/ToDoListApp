//
//  Item.swift
//  ToDoListApp
//
//  Created by Joy on 04/06/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var name: String
    var details: String
    var isCompleted: Bool
    var creationDate: Date
    var dueDate: Date?
    var category: String
    
    init(name: String, details: String = "", isCompleted: Bool = false, creationDate: Date = Date(), dueDate: Date? = nil, category: String = "Default") {
        self.name = name
        self.details = details
        self.isCompleted = isCompleted
        self.creationDate = creationDate
        self.dueDate = dueDate
        self.category = category
    }

    var isOverdue: Bool {
        if let dueDate = dueDate, !isCompleted {
            // Compare dueDate with the start of today
            return dueDate < Calendar.current.startOfDay(for: Date())
        }
        return false
    }
}
