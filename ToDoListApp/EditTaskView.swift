//
//  EditTaskView.swift
//  ToDoListApp
//
//  Created by Joy on 04/06/2025.
//

import SwiftUI
import SwiftData

struct EditTaskView: View {
    @Bindable var item: Item
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss

    @State private var datePickerDate: Date

    init(item: Item) {
        self.item = item
        // Initialize _datePickerDate with item.dueDate or current date if nil
        self._datePickerDate = State(initialValue: item.dueDate ?? Date())
    }

    var body: some View {
        Form {
            Section(header: Text("Task Details")) {
                TextField("Name", text: $item.name)
                TextField("Details", text: $item.details, axis: .vertical)
                TextField("Category", text: $item.category)
            }

            Section(header: Text("Due Date")) {
                DatePicker("Due Date", selection: $datePickerDate, displayedComponents: .date)
                Button("Clear Due Date") {
                    item.dueDate = nil
                    datePickerDate = Date() // Reset state date for DatePicker
                }
            }
        }
        .navigationTitle("Edit Task")
        .toolbar {
            // No explicit save button needed as @Bindable updates the model directly.
            // A toolbar could be added here for other actions if needed in the future.
        }
        .onChange(of: datePickerDate) { oldValue, newValue in
            item.dueDate = newValue
        }
        .onChange(of: item.dueDate) { oldValue, newValue in
            // Update datePickerDate if item.dueDate changes externally or is cleared
            datePickerDate = newValue ?? Date()
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Item.self, configurations: config)
        let exampleItem = Item(name: "Sample Task", details: "Sample details", dueDate: Date(), category: "Sample Category")
        return EditTaskView(item: exampleItem)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container for preview: \(error.localizedDescription)")
    }
}
