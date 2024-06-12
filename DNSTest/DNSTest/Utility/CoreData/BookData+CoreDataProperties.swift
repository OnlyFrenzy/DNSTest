import Foundation
import CoreData


extension BookData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookData> {
        return NSFetchRequest<BookData>(entityName: "BookData")
    }

    @NSManaged public var name: String?
    @NSManaged public var author: String?
    @NSManaged public var year: Int16

}

extension BookData : Identifiable {

}
