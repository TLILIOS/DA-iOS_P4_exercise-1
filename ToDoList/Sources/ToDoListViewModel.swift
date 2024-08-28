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
        self.displayedItems = allItems
    }

    // MARK: - Outputs
    /// Publisher for the list of to-do items.
    @Published var displayedItems: [ToDoItem] = [] {
        didSet {
            repository.saveToDoItems(displayedItems)
        }
    
    }

    // MARK: - Inputs

    // Add a new to-do item with priority and category
    func add(item: ToDoItem) {
        allItems.append(item)
        applyCurrentFilter()
    }

    /// Toggles the completion status of a to-do item.
    func toggleTodoItemCompletion(_ item: ToDoItem) {
        if let index = allItems.firstIndex(where: { $0.id == item.id }) {
            allItems[index].isDone.toggle()
            applyCurrentFilter()
        }
    }

    /// Removes a to-do item from the list.
    func removeTodoItem(_ item: ToDoItem) {
        allItems.removeAll { $0.id == item.id }
        applyCurrentFilter()
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
                displayedItems = allItems
            case .completed:
                displayedItems = allItems.filter{ $0.isDone }
            case .notCompleted:
                displayedItems = allItems.filter{ !$0.isDone }
                
            }

        }
    
}
