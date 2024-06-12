import UIKit

class SortTableViewCell: UITableViewCell {
    
    private lazy var sortLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = .zero
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

        sortLabel.text = .empty
    }
    
    func setupView(sortType: ListSortType) {
        sortLabel.text = sortType.rawValue
        
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        addSubviews([sortLabel, separatorView])
    }
    
    private func addConstraints() {
        
        sortLabel.translatesAutoresizingMaskIntoConstraints = false
        sortLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Spaces.space16).isActive = true
        sortLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: Spaces.space16).isActive = true
        sortLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Spaces.space16).isActive = true
        
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: .zero).isActive = true
        separatorView.topAnchor.constraint(equalTo: sortLabel.bottomAnchor, constant: Spaces.space16).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: .zero).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: .zero).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: Sizes.size1).isActive = true
    }
}
