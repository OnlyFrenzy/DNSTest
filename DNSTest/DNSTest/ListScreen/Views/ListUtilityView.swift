import UIKit

protocol ListUtilityViewDelegate: AnyObject {
    func sortButtonDidTap()
    func addButtonDidTap()
}

class ListUtilityView: UIView {
    
    private weak var delegate: ListUtilityViewDelegate?
    
    private lazy var containerStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.spacing = Spaces.space16
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private lazy var sortButton: UIButton = {
        var button = UIButton()
        button.setTitle(ListSortType.name.rawValue, for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(sortButtonDidTap), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var addButton: UIButton = {
        var button = UIButton()
        button.setImage(Images.plus, for: .normal)
        button.addTarget(self, action: #selector(addButtonDidTap), for: .touchUpInside)
        
        return button
    }()
    
    init(delegate: ListUtilityViewDelegate) {
        self.delegate = delegate
        
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeSortType(sortType: ListSortType) {
        sortButton.setTitle(sortType.rawValue, for: .normal)
    }
    
    private func setupView() {
        backgroundColor = .black
        
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        addSubview(containerStackView)
        containerStackView.addArrangedSubviews([sortButton, addButton])
    }
    
    private func addConstraints() {
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Spaces.space16).isActive = true
        containerStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: Spaces.space16).isActive = true
        containerStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Spaces.space16).isActive = true
        containerStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Spaces.space16).isActive = true
        containerStackView.heightAnchor.constraint(equalToConstant: Sizes.size40).isActive = true
        
        addButton.widthAnchor.constraint(equalToConstant: Sizes.size40).isActive = true
    }
    
    @objc
    private func addButtonDidTap() {
        delegate?.addButtonDidTap()
    }
    
    @objc
    private func sortButtonDidTap() {
        delegate?.sortButtonDidTap()
    }
}
