import UIKit

class SortScreenViewController: UIViewController {
    
    private let sortTypeDidChange: (ListSortType) -> ()
    
    private lazy var sortTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SortTableViewCell.self, forCellReuseIdentifier: SortTableViewCell.className)
        
        return tableView
    }()
    
    init(sortTypeDidChange: @escaping (ListSortType) -> ()) {
        self.sortTypeDidChange = sortTypeDidChange
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        sortTableView.dataSource = self
        sortTableView.delegate = self
        
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(sortTableView)
    }
    
    private func addConstraints() {
        sortTableView.translatesAutoresizingMaskIntoConstraints = false
        sortTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: .zero).isActive = true
        sortTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: .zero).isActive = true
        sortTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: .zero).isActive = true
        sortTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: .zero).isActive = true
    }
}

extension SortScreenViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ListSortType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SortTableViewCell.className, for: indexPath) as! SortTableViewCell
        cell.setupView(sortType: ListSortType.allCases[indexPath.row])
        return cell
    }
}

extension SortScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sortTypeDidChange(ListSortType.allCases[indexPath.row])
    }
}
