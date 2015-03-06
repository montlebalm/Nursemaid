import CoreData
import Foundation

class BottleFeeding: NSManagedObject {
  
  @NSManaged var ounces: NSNumber
  @NSManaged var endTime: NSDate

}
