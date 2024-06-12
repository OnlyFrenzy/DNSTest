import UIKit

protocol ListCoordinatorProtocol: AnyObject {
    func sortButtonDidTap(sortTypeDidChange: @escaping (ListSortType) -> ())
    func addBookDidTap(bookDidAdded:@escaping () -> ())
    func updateBookDidTap(bookForUpdate: Book?, bookDidUpdated:@escaping () -> ())
}

class ListCoordinator: Coordinator, ListCoordinatorProtocol {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    private let coreDataManager: CoreDataManager
    
    init(
        navigationController: UINavigationController,
        coreDataManager: CoreDataManager
    ) {
        self.navigationController = navigationController
        self.coreDataManager = coreDataManager
    }
    
    func start() {
        let viewModel = ListViewModel(coreDataManager: coreDataManager, coordinator: self)
        let viewController = ListViewController(viewModel: viewModel, navigationBar: navigationController.navigationBar)
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func sortButtonDidTap(sortTypeDidChange: @escaping (ListSortType) -> ()) {
        let viewController = SortScreenViewController(sortTypeDidChange: sortTypeDidChange)
        
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        navigationController.present(viewController, animated: true)
    }
    
    func addBookDidTap(bookDidAdded: @escaping () -> ()) {
        addUpdateBook(bookForUpdate: nil, bookDidAddedUpdated: bookDidAdded, addButtonStyle: .add)
    }
    
    func updateBookDidTap(bookForUpdate: Book?, bookDidUpdated:@escaping () -> ()) {
        addUpdateBook(bookForUpdate: bookForUpdate, bookDidAddedUpdated: bookDidUpdated, addButtonStyle: .edit)
    }
    
    private func addUpdateBook(bookForUpdate: Book?, bookDidAddedUpdated:@escaping () -> (), addButtonStyle: AddButtonStyle) {
        let viewModel = BookViewModel(
            coreDataManager: coreDataManager,
            coordinator: self,
            bookForUpdate: bookForUpdate,
            bookDidAdded:
                { [weak self] in
                    self?.navigationController.dismiss(animated: true)
                    bookDidAddedUpdated()
                }
        )
        let viewController = BookViewController(viewModel: viewModel, addButtonStyle: addButtonStyle)
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        navigationController.present(viewController, animated: true)
    }
}
