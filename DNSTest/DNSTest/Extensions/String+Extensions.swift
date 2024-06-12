import Foundation

extension String {
    static var empty: String {
        get { return "" }
    }
    
    var isNumeric: Bool {
      return !(self.isEmpty) && self.allSatisfy { $0.isNumber }
    }
}
