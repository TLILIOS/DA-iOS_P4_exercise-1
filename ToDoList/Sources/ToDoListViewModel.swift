import SwiftUI

final class ToDoListViewModel: ObservableObject {
    // MARK: - Private properties

    private let repository: ToDoListRepositoryType
    private var allItems: [ToDoItem] = []
    private var currentFilter: FilterOption = .all
    // MARK: - Init

    init(repository: ToDoListRepositoryType) {
        self.repository = repository
        self.allItems = repository.loadToDoItems()
        self.toDoItems = allItems
    }

    // MARK: - Outputs
    /// Publisher for the list of to-do items.
    @Published var toDoItems: [ToDoItem] = [] {
        didSet {
            repository.saveToDoItems(toDoItems)
        }
    
    }

    // MARK: - Inputs

    // Add a new to-do item with priority and category
    func add(item: ToDoItem) {
        allItems.append(item)
        applyCurrentFilter()
//        applyFilter(at: 0)
//        saveChange()
    }

    /// Toggles the completion status of a to-do item.
    func toggleTodoItemCompletion(_ item: ToDoItem) {
        if let index = allItems.firstIndex(where: { $0.id == item.id }) {
            allItems[index].isDone.toggle()
            applyCurrentFilter()
            // Fixed ?
//            applyFilter(at: 0)
//            saveChange()
        }
    }

    /// Removes a to-do item from the list.
    func removeTodoItem(_ item: ToDoItem) {
        allItems.removeAll { $0.id == item.id }
        applyCurrentFilter()
        //Fixed ?
//        applyFilter(at: 0)
//    saveChange()
    }

   // Enumeration to represent filter options
    enum FilterOption: Int {
        case all = 0
        case completed = 1
        case notCompleted = 2
    }
    
    /// Apply the filter to update the list.
    func applyFilter(at index: Int) {
        // TODO: - Implement the logic for filtering
        guard let filterOption = FilterOption(rawValue: index) else {return}
        currentFilter = filterOption
        applyCurrentFilter()
    }
        func applyCurrentFilter() {
            switch currentFilter {
            case .all:
                toDoItems = allItems
            case .completed:
                toDoItems = allItems.filter{ $0.isDone }
            case .notCompleted:
                toDoItems = allItems.filter{ !$0.isDone }
                
            }
            repository.saveToDoItems(allItems)
        }
    
    //Save changes to the repository
//    func saveChange() {
//        repository.saveToDoItems(toDoItems)
//    }
    
    
}
