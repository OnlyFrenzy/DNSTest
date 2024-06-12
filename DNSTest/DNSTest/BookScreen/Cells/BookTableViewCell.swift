import UIKit

class BookTableViewCell: UITableViewCell {
    
    private weak var textFieldDelegate: UITextFieldDelegate?
    
    private lazy var containerStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.spacing = Spaces.space8
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.isUserInteractionEnabled = true
        
        return stackView
    }()
    
    private lazy var label = UILabel()
    private var textField: BookTextField?
    
    private lazy var separatorView: UIView = {
        var separator = UIView()
        separator.backgroundColor = .gray
        
        return separator
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()

        label.text = .empty
        textField?.text = .empty
    }
    
    func setupView(
        id: Int,
        title: String,
        text: String,
        textFieldDelegate: BookTextFieldDelegate,
        keyboardType: UIKeyboardType
    ) {
        textField = BookTextField(id: id, bookTextFieldDelegate: textFieldDelegate)
        textField?.text = text
        textField?.keyboardType = keyboardType
        textField?.autocorrectionType = .no
        textField?.spellCheckingType = .no
        
        label.text = title
        
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        guard let textField = textField else { return }
        containerStackView.addArrangedSubviews([label, textField])
        addSubviews([containerStackView, separatorView])
    }
    
    private func addConstraints() {
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Spaces.space16).isActive = true
        containerStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: Spaces.space16).isActive = true
        containerStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Spaces.space16).isActive = true
        
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: .zero).isActive = true
        separatorView.topAnchor.constraint(equalTo: containerStackView.bottomAnchor, constant: Spaces.space16).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: .zero).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: .zero).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: Sizes.size1).isActive = true
    }
}
