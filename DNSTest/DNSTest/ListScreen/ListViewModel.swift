import Foundation

protocol ListViewModelProtocol: ViewModel {
    func getBooks() -> [Book]
    func getBook(index: Int) -> Book
    func addBookDidTap(bookDidAdded: @escaping () -> ())
    func updateBookDidTap(id: Int, bookDidUpdated: @escaping () -> ())
    func deleteBookDidTap(id: Int, bookDidDeleted: @escaping () -> ())
    func sortButtonDidTap(sortTypeDidChanged: @escaping (ListSortType) -> ())
    func prepareData(dataWasPrepared: () -> ())
    func changeSortType(sortType: ListSortType, sortTypeDidChanged: () -> ())
    func search(text: String)
}

class ListViewModel: ListViewModelProtocol {
    
    private let coreDataManager: CoreDataManagerProtocol
    private weak var coordinator: ListCoordinatorProtocol?
    
    private var sortType: ListSortType = .name
    private var searchText: String = .empty
    private var books: [Book] = []
    private var searchedBooks: [Book] = []
    
    init(
        coreDataManager: CoreDataManagerProtocol,
        coordinator: ListCoordinatorProtocol
    ) {
        self.coreDataManager = coreDataManager
        self.coordinator = coordinator
    }
    
    func getBooks() -> [Book] {
        return searchText.isEmpty ? books : searchedBooks
    }
    
    func getBook(index: Int) -> Book {
        return searchText.isEmpty ? books[index] : searchedBooks[index]
    }
    
    func addBookDidTap(bookDidAdded: @escaping () -> ()) {
        coordinator?.addBookDidTap(bookDidAdded: bookDidAdded)
    }
    
    func updateBookDidTap(id: Int, bookDidUpdated: @escaping () -> ()) {
        coordinator?.updateBookDidTap(bookForUpdate: books[id], bookDidUpdated: bookDidUpdated)
    }
    
    func deleteBookDidTap(id: Int, bookDidDeleted: @escaping () -> ()) {
        coreDataManager.deleteContext(book: books[id], dataDidFetch: bookDidDeleted)
    }
    
    func prepareData(dataWasPrepared: () -> ()) {
        fetchData()
        sortBooks(sortType: sortType)
        dataWasPrepared()
    }
    
    func sortButtonDidTap(sortTypeDidChanged: @escaping (ListSortType) -> ()) {
        coordinator?.sortButtonDidTap(sortTypeDidChange: sortTypeDidChanged)
    }
    
    func changeSortType(sortType: ListSortType, sortTypeDidChanged: () -> ()) {
        if self.sortType != sortType {
            self.sortType = sortType
            sortBooks(sortType: sortType)
        }
        sortTypeDidChanged()
    }
    
    func search(text: String) {
        searchText = text
        if text.isNumeric {
            searchedBooks = books.filter { String($0.year).contains(text) }
        } else {
            searchedBooks = books.filter { $0.name.contains(text) || $0.author.contains(text) }
        }
    }
    
    private func fetchData() {
        coreDataManager.fetchData { booksData in
            books = convertBooksDataToBooks(booksData)
        }
    }
    
    private func convertBooksDataToBooks(_ booksData: [BookData]) -> [Book] {
        var newBooks: [Book] = []
        booksData.forEach { bookData in
            newBooks.append(Book(
                id: bookData.id,
                name: bookData.name ?? .empty,
                author: bookData.author ?? .empty,
                year: bookData.year
            ))
        }
        return newBooks
    }
    
    private func sortBooks(sortType: ListSortType) {
        switch sortType {
        case .name:
            books = books.sorted(by: { $0.name < $1.name })
        case .author:
            books = books.sorted(by: { $0.author < $1.author })
        case.year:
            books = books.sorted(by: { $0.year < $1.year })
        }
        search(text: searchText)
    }
}
