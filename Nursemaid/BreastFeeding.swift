import CoreData
import Foundation

class BreastFeeding: NSManagedObject {
  
  @NSManaged var startTime: NSDate
  @NSManaged var endTime: NSDate
  @NSManaged var leftSideSeconds: NSNumber
  @NSManaged var rightSideSeconds: NSNumber
  @NSManaged var lastSide: String
  
  class func createInContext(context: NSManagedObjectContext, leftSeconds: Int, rightSeconds: Int, lastSide: String, startTime: NSDate, endTime: NSDate) -> BreastFeeding {
    let feeding = NSEntityDescription.insertNewObjectForEntityForName("BreastFeeding", inManagedObjectContext: context) as BreastFeeding
    feeding.startTime = startTime
    feeding.endTime = endTime
    feeding.leftSideSeconds = leftSeconds
    feeding.rightSideSeconds = rightSeconds
    feeding.lastSide = lastSide
    return feeding
  }
  
}
