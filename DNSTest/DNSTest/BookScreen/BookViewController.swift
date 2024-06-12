import UIKit

class BookViewController: UIViewController {
    
    private let viewModel: BookViewModelProtocol?
    private let addButtonStyle: AddButtonStyle
    
    private lazy var bookTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(BookTableViewCell.self, forCellReuseIdentifier: BookTableViewCell.className)
        
        return tableView
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(addButtonDidTap), for: .touchUpInside)
        button.layer.cornerRadius = Spaces.space8
        
        return button
    }()
    
    init(viewModel: BookViewModelProtocol?, addButtonStyle: AddButtonStyle) {
        self.viewModel = viewModel
        self.addButtonStyle = addButtonStyle
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
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewDidTap)))
        
        bookTableView.dataSource = self
        
        configureAddButton(style: addButtonStyle)
        
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        view.addSubviews([bookTableView, addButton])
    }
    
    private func addConstraints() {
        bookTableView.translatesAutoresizingMaskIntoConstraints = false
        bookTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: .zero).isActive = true
        bookTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: .zero).isActive = true
        bookTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: .zero).isActive = true
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Spaces.space16).isActive = true
        addButton.topAnchor.constraint(equalTo: bookTableView.bottomAnchor, constant: .zero).isActive = true
        addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Spaces.space16).isActive = true
        addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Spaces.space16).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: Sizes.size40).isActive = true
    }
    
    @objc
    private func viewDidTap() {
        self.view.endEditing(true)
    }
    
    @objc
    private func addButtonDidTap() {
        viewDidTap()
        viewModel?.addBookDidTap(cantAddBook: { [weak self] in
            self?.configureAddButton(style: .editAllFields)
        })
    }
    
    private func configureAddButton(style: AddButtonStyle) {
        switch style {
        case .add, .edit:
            addButton.backgroundColor = .black
        case .editAllFields:
            addButton.backgroundColor = .red
        }
        addButton.setTitle(style.rawValue, for: .normal)
    }
}

extension BookViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BookField.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.className, for: indexPath) as! BookTableViewCell
        let bookField = BookField.allCases[indexPath.row]
        cell.setupView(
            id: indexPath.row,
            title: BookField.allCases[indexPath.row].rawValue,
            text: viewModel?.bookFieldText(for: bookField) ?? .empty,
            textFieldDelegate: self,
            keyboardType: bookField == .year ? .numberPad : .default
        )
        cell.contentView.isUserInteractionEnabled = false
        cell.selectionStyle = .none
        return cell
    }
}

extension BookViewController: BookTextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, id: Int) {
        viewModel?.changeText(on: BookField.allCases[id], to: textField.text)
        configureAddButton(style: addButtonStyle)
    }
}
