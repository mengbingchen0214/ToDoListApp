//
//  ContentView.swift
//  ToDoListApp
//
//  Created by Joy on 04/06/2025.
//

import SwiftUI
import SwiftData

enum SortOption: String, CaseIterable, Identifiable {
    case byCreationDateDescending = "Newest First"
    case byCreationDateAscending = "Oldest First"
    case byDueDateAscending = "Due Date (Earliest First)"
    case byDueDateDescending = "Due Date (Latest First)"
    case byNameAscending = "Name (A-Z)"
    case byNameDescending = "Name (Z-A)"
    case byCompletionStatus = "Completion Status"

    var id: String { self.rawValue }
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    // The @Query's sort will be overridden by our manual sort, but it's fine to keep a default.
    @Query(sort: [SortDescriptor(\Item.creationDate, order: .reverse)]) private var items: [Item]
    @State private var selectedCategory: String? = nil
    @State private var newTaskName: String = ""
    @State private var searchText: String = ""
    @State private var currentSortOption: SortOption = .byCreationDateDescending

    private var uniqueCategories: [String] {
        Array(Set(items.map { $0.category })).sorted()
    }

    private var filteredAndSortedItems: [Item] {
        var tempItems = items

        // Filter by category
        if let category = selectedCategory {
            tempItems = tempItems.filter { $0.category == category }
        }

        // Filter by search text
        if !searchText.isEmpty {
            tempItems = tempItems.filter { item in
                item.name.localizedCaseInsensitiveContains(searchText) ||
                item.details.localizedCaseInsensitiveContains(searchText)
            }
        }

        // Sort items
        switch currentSortOption {
        case .byCreationDateDescending:
            tempItems.sort { $0.creationDate > $1.creationDate }
        case .byCreationDateAscending:
            tempItems.sort { $0.creationDate < $1.creationDate }
        case .byDueDateAscending:
            tempItems.sort {
                guard let dueDate1 = $0.dueDate else { return false } // nil due dates go to the end
                guard let dueDate2 = $1.dueDate else { return true }
                return dueDate1 < dueDate2
            }
        case .byDueDateDescending:
            tempItems.sort {
                guard let dueDate1 = $0.dueDate else { return false }
                guard let dueDate2 = $1.dueDate else { return true }
                return dueDate1 > dueDate2
            }
        case .byNameAscending:
            tempItems.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .byNameDescending:
            tempItems.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedDescending }
        case .byCompletionStatus:
            tempItems.sort { !$0.isCompleted && $1.isCompleted } // Incomplete tasks first
        }
        return tempItems
    }

    var body: some View {
        NavigationSplitView {
            VStack {
                List {
                    ForEach(filteredAndSortedItems) { item in
                        NavigationLink(destination: EditTaskView(item: item)) {
                            HStack {
                                Button {
                                    withAnimation {
                                        item.isCompleted.toggle()
                                    }
                                } label: {
                                    Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                }
                                .buttonStyle(BorderlessButtonStyle()) // To prevent the whole row from being a button

                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .strikethrough(item.isCompleted) // Use default strikethrough color

                                    if let dueDate = item.dueDate {
                                        (Text(LocalizedStringKey("due_date_prefix")) + Text(dueDate, formatter: Self.dateFormatter))
                                            .font(.caption)
                                            .foregroundColor(item.isOverdue ? .red : .gray)
                                    }
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteItems)
                }

                HStack {
                    TextField(LocalizedStringKey("Add new task..."), text: $newTaskName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onSubmit(submitNewTask)
                    Button(action: submitNewTask) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.green)
                    }
                    .disabled(newTaskName.isEmpty)
                }
                .padding()
            }
            .searchable(text: $searchText, prompt: Text(LocalizedStringKey("Search tasks")))
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Picker(LocalizedStringKey("Category"), selection: $selectedCategory) {
                        Text(LocalizedStringKey("All Categories")).tag(nil as String?)
                        ForEach(uniqueCategories, id: \.self) { category in
                            Text(category).tag(category as String?) // Categories are user-defined, not localized here
                        }
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Picker(LocalizedStringKey("Sort By"), selection: $currentSortOption) {
                        ForEach(SortOption.allCases) { option in
                            Text(option.rawValue).tag(option) // Uses rawValue as key
                        }
                    }
                    EditButton() // Keep EditButton
                }
                // Keep existing Add Item button
                ToolbarItem(placement: .bottomBar) { // Moved to bottomBar for space, or could be with Edit
                     Button {
                        addItem()
                     } label: {
                        Label(LocalizedStringKey("Add Item"), systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text(LocalizedStringKey("Select an item"))
        }
    }

    // Date formatter for displaying due dates
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    private func addItem() { // This function is now for the toolbar button, not quick add
        withAnimation {
            let newItem = Item(name: NSLocalizedString("New Task from Toolbar", comment: "Default name for task created via toolbar button"), creationDate: Date())
            modelContext.insert(newItem)
        }
    }

    private func submitNewTask() {
        guard !newTaskName.isEmpty else { return }
        withAnimation {
            let newItem = Item(name: newTaskName, creationDate: Date())
            modelContext.insert(newItem)
            newTaskName = "" // Reset TextField
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
