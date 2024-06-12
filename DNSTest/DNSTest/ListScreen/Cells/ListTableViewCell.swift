import UIKit

class ListTableViewCell: UITableViewCell {
    
    private lazy var containerStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.spacing = Spaces.space16
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private lazy var nameAuthorStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.spacing = Spaces.space16
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private lazy var nameLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = .zero
        label.sizeToFit()
        
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = .zero
        label.sizeToFit()
        
        return label
    }()
    
    private lazy var yearLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .right
        label.sizeToFit()
        
        return label
    }()
    
    private lazy var separatorView: UIView = {
        var separator = UIView()
        separator.backgroundColor = .gray
        
        return separator
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()

        nameLabel.text = .empty
        authorLabel.text = .empty
        yearLabel.text = .empty
    }
    
    func setupView(book: Book) {
        
        nameLabel.text = book.name
        authorLabel.text = book.author
        yearLabel.text = "\(book.year)"
        
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        nameAuthorStackView.addArrangedSubviews([nameLabel, authorLabel])
        containerStackView.addArrangedSubviews([nameAuthorStackView, yearLabel])
        
        addSubviews([containerStackView, separatorView])
    }
    
    private func addConstraints() {
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        yearLabel.widthAnchor.constraint(equalToConstant: Sizes.size48).isActive = true
        
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
