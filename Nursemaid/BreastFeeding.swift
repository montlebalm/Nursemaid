import Foundation

class BreastFeeding {

  let id: String
  let startTime: NSDate
  var endTime: NSDate!
  var leftBreastSeconds = 0
  var rightBreastSeconds = 0

  init(id: String, startTime: NSDate) {
    self.id = id
    self.startTime = startTime
  }

}
