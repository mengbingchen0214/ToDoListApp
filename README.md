# ToDoListApp - iOS

A simple and practical to-do list application for iOS, built with SwiftUI and SwiftData.

## Features

*   **Task Management**:
    *   Add new tasks with a name, details, category, and due date.
    *   Edit existing tasks.
    *   Delete tasks using a swipe gesture.
    *   Mark tasks as complete/incomplete with a tap, including a visual strikethrough and animation.
*   **Task List**:
    *   Displays all tasks, clearly distinguishing between completed and uncompleted items.
    *   Shows due dates and highlights overdue tasks in red.
*   **Categorization**:
    *   Assign custom categories to tasks (e.g., "Work", "Personal", "Shopping").
    *   Filter the task list by selected category.
*   **Due Dates**:
    *   Set optional due dates for tasks using a date picker.
    *   Overdue tasks are visually highlighted.
*   **Quick Add**:
    *   A dedicated TextField at the bottom of the list for quickly adding tasks by name.
*   **Search**:
    *   Search tasks by keywords in their name or details.
*   **Sorting**:
    *   Sort tasks by:
        *   Creation Date (Newest/Oldest)
        *   Due Date (Earliest/Latest)
        *   Name (A-Z/Z-A)
        *   Completion Status (Incomplete first)
*   **User Interface**:
    *   Clean and intuitive interface built with SwiftUI.
    *   Supports system light and dark modes.
    *   Simple animations for user interactions like task completion.

## Requirements

*   iOS 17.0+ (due to SwiftData usage)
*   Xcode 15.0+

## How to Build and Run

1.  Clone this repository.
2.  Open the `ToDoListApp.xcodeproj` file in Xcode.
3.  Select a simulator or a connected iOS device.
4.  Click the "Run" button (or Product > Run).

## Project Structure

*   **`ToDoListApp/`**: Contains the main application source code.
    *   **`Item.swift`**: The SwiftData model for a to-do item.
    *   **`ContentView.swift`**: The main view displaying the task list, search, sort, and quick add features.
    *   **`EditTaskView.swift`**: The view used for adding and editing task details.
    *   **`ToDoListAppApp.swift`**: The main entry point for the application.
    *   **`Assets.xcassets`**: Contains app icons and accent colors.
*   **`ToDoListApp.xcodeproj/`**: Xcode project file.
*   **`prompt.md`**: The original requirements document for the app.
*   **`README.md`**: This file.

## Future Enhancements

*   **Advanced Repeating Tasks**: Allow users to set tasks that repeat on daily, weekly, monthly, or custom schedules.
*   **Cloud Synchronization**: Integrate with iCloud (SwiftData's native capability) or other cloud services to sync tasks across multiple devices.
*   **Notifications & Reminders**: Implement local notifications to remind users of upcoming or overdue tasks.
*   **Customizable Categories**: Allow users to define categories with custom names and assign colors to them for better visual organization.
*   **Subtasks**: Support for breaking down larger tasks into smaller, manageable subtasks.
*   **Attachments**: Allow users to attach images or files to tasks.
*   **Themes & Appearance Customization**: Offer different themes or more granular control over the app's appearance beyond system light/dark mode.
*   **Expanded Language Support**: Add support for more languages based on user demand.
*   **iOS Widgets**: Create home screen widgets for quick task viewing or adding.
*   **Collaboration**: Allow sharing of task lists with other users for collaborative projects.
*   **Gamification**: Introduce points or rewards for task completion to motivate users.
*   **Siri Integration**: Allow adding or querying tasks using Siri.
