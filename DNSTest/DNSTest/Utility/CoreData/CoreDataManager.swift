import Foundation
import CoreData

protocol CoreDataManagerProtocol {
    func fetchData(dataDidFetch: ([BookData]) -> ())
    func saveContext(book: Book, dataDidFetch: () -> ())
    func deleteContext(book: Book, dataDidFetch: () -> ())
}

class CoreDataManager: CoreDataManagerProtocol {
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DNSTest")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var booksData: [BookData] = []
    
    func fetchData(dataDidFetch: ([BookData]) -> ()) {
        let bookFetch: NSFetchRequest<BookData> = BookData.fetchRequest()
        
        do {
            let manageContent = persistentContainer.viewContext
            booksData = try manageContent.fetch(bookFetch)
            dataDidFetch(booksData)
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
    
    func saveContext (book: Book, dataDidFetch: () -> ()) {
        let manageContent = persistentContainer.viewContext
        var bookData: BookData
        if let bookId = book.id {
            bookData = booksData.first { $0.id == bookId } ?? BookData(context: manageContent)
        } else {
            bookData = BookData(context: manageContent)
        }
        
        bookData.setValue(book.name, forKey: #keyPath(BookData.name))
        bookData.setValue(book.author, forKey: #keyPath(BookData.author))
        bookData.setValue(book.year, forKey: #keyPath(BookData.year))
        
        do{
            try manageContent.save()
            fetchData(dataDidFetch: { _ in dataDidFetch() })
        }catch let error as NSError {
            print("could not save . \(error), \(error.userInfo)")
        }
    }
    
    func deleteContext(book: Book, dataDidFetch: () -> ()) {
        guard let bookId = book.id,
        let bookData = booksData.first(where: { $0.id == bookId }) else { return }
        
        let manageContent = persistentContainer.viewContext
        manageContent.delete(bookData)
        
        do{
            try manageContent.save()
            fetchData(dataDidFetch: { _ in dataDidFetch() })
        }catch let error as NSError {
            print("could not save . \(error), \(error.userInfo)")
        }
    }
}
