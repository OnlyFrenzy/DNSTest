import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    private let coreDataManager = CoreDataManager()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let listCoordinator = ListCoordinator(
            navigationController: navigationController,
            coreDataManager: coreDataManager
        )
        childCoordinators.append(listCoordinator)
        listCoordinator.start()
    }
}
