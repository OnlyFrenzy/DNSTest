import UIKit

private enum Constants {
    static let delete = "Delete"
    static let edit = "Edit"
}

class ListViewController: UIViewController {
    private let viewModel: ListViewModelProtocol?
    private let navigationBar: UINavigationBar?
    
    private var searchTimer: Timer?
    
    private lazy var listUtilityView: ListUtilityView = ListUtilityView(delegate: self)
    
    private lazy var searchBar = UISearchBar()
    
    private lazy var listTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.className)
        
        return tableView
    }()
    
    init(
        viewModel: ListViewModelProtocol?,
        navigationBar: UINavigationBar?
    ) {
        self.viewModel = viewModel
        self.navigationBar = navigationBar
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        viewModel?.prepareData { listTableView.reloadData() }
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        navigationBar?.isHidden = true
        
        listTableView.dataSource = self
        listTableView.delegate = self
        
        searchBar.delegate = self
        
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        view.addSubviews([searchBar, listUtilityView, listTableView])
    }
    
    private func addConstraints() {
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: .zero).isActive = true
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: .zero).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: .zero).isActive = true
        
        listUtilityView.translatesAutoresizingMaskIntoConstraints = false
        listUtilityView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: .zero).isActive = true
        listUtilityView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: .zero).isActive = true
        listUtilityView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: .zero).isActive = true
        
        listTableView.translatesAutoresizingMaskIntoConstraints = false
        listTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: .zero).isActive = true
        listTableView.topAnchor.constraint(equalTo: listUtilityView.bottomAnchor, constant: .zero).isActive = true
        listTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: .zero).isActive = true
        listTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: .zero).isActive = true
    }
}

extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getBooks().count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.className, for: indexPath) as! ListTableViewCell
        cell.setupView(book: viewModel.getBook(index: indexPath.row))
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteItem = UIContextualAction(style: .destructive, title: Constants.delete) { [weak self] (contextualAction, view, boolValue) in
            self?.viewModel?.deleteBookDidTap(id: indexPath.row, bookDidDeleted: {
                self?.viewModel?.prepareData { self?.listTableView.reloadData() }
            })
        }
        
        let editItem = UIContextualAction(style: .normal, title: Constants.edit) { [weak self] (contextualAction, view, boolValue) in
            self?.viewModel?.updateBookDidTap(id: indexPath.row, bookDidUpdated: {
                self?.viewModel?.prepareData { self?.listTableView.reloadData() }
            })
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [editItem, deleteItem])
        
        return swipeActions
    }
}

extension ListViewController: ListUtilityViewDelegate {
    func addButtonDidTap() {
        viewModel?.addBookDidTap(bookDidAdded: { [weak self] in
            self?.viewModel?.prepareData { self?.listTableView.reloadData() }
        })
    }
    
    func sortButtonDidTap() {
        viewModel?.sortButtonDidTap(sortTypeDidChanged: { [weak self] sortType in
            self?.listUtilityView.changeSortType(sortType: sortType)
            self?.viewModel?.changeSortType(
                sortType: sortType,
                sortTypeDidChanged: {
                    self?.listTableView.reloadData()
                })
        })
    }
}

extension ListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] timer in
            self?.viewModel?.search(text: searchText)
            self?.searchTimer = nil
            self?.listTableView.reloadData()
        }
    }
}
