import Foundation

protocol BookViewModelProtocol: ViewModel {
    func addBookDidTap(cantAddBook: () -> ())
    func changeText(on bookField: BookField, to text: String?)
    func bookFieldText(for bookField: BookField) -> String
}

class BookViewModel: BookViewModelProtocol {
    
    private let coreDataManager: CoreDataManager
    private weak var coordinator: ListCoordinatorProtocol?
    private let bookDidAdded: () -> ()
    private let bookForUpdate: Book?
    
    private var nameText: String = .empty
    private var authorText: String = .empty
    private var year: Int16?
    
    init(
        coreDataManager: CoreDataManager,
        coordinator: ListCoordinatorProtocol,
        bookForUpdate: Book?,
        bookDidAdded: @escaping () -> ()
    ) {
        self.coreDataManager = coreDataManager
        self.coordinator = coordinator
        self.bookForUpdate = bookForUpdate
        self.bookDidAdded = bookDidAdded
        if let bookForUpdate = bookForUpdate {
            nameText = bookForUpdate.name
            authorText = bookForUpdate.author
            year = bookForUpdate.year
        }
    }
    
    func addBookDidTap(cantAddBook: () -> ()) {
        guard let year = year,
              !nameText.isEmpty,
              !authorText.isEmpty
        else {
            cantAddBook()
            return
        }
        
        coreDataManager.saveContext(book: Book(
            id: bookForUpdate?.id,
            name: nameText,
            author: authorText,
            year: year
        )) {
            bookDidAdded()
        }
    }
    
    func changeText(on bookField: BookField, to text: String?) {
        guard let text = text, !text.isEmpty else { return }
        switch bookField {
        case .name:
            nameText = text
        case .author:
            authorText = text
        case .year:
            year = Int16(text)
        }
    }
    
    func bookFieldText(for bookField: BookField) -> String {
        switch bookField {
        case .name:
            return bookForUpdate?.name ?? .empty
        case .author:
            return bookForUpdate?.author ?? .empty
        case .year:
            guard let year = bookForUpdate?.year else { return .empty }
            return String(year)
        }
    }
}
