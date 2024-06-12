import UIKit

protocol BookTextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, id: Int)
}

class BookTextField: UITextField {
    
    private let id: Int
    private let bookTextFieldDelegate: BookTextFieldDelegate
    
    init(id: Int, bookTextFieldDelegate: BookTextFieldDelegate) {
        self.id = id
        self.bookTextFieldDelegate = bookTextFieldDelegate
        super.init(frame: .zero)
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BookTextField: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        bookTextFieldDelegate.textFieldDidEndEditing(textField, id: id)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
