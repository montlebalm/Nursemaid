import Foundation

public class BreastService {

  var fakeIdCtr = 0

  var data: [Breastfeeding] = []

  init() {}

  func all(callback: (NSError?, [Breastfeeding]) -> ()) {
    callback(nil, data)
  }

  func create(endTime: NSDate, lastSide: String, leftSeconds: Int, rightSeconds: Int, callback: (NSError?, Breastfeeding?) -> ()) {
    data.append(Breastfeeding(
      id: String(++fakeIdCtr),
      userId: "2",
      endTime: endTime,
      leftSideSeconds: leftSeconds,
      rightSideSeconds: rightSeconds,
      lastSide: lastSide
    ))
    last(callback)
  }

  func last(callback: (NSError?, Breastfeeding?) -> ()) {
    callback(nil, data.last)
  }

  func remove(id: String, callback: (NSError?) -> ()) {
    for i in 0..<data.count {
      if data[i].id == id {
        data.removeAtIndex(i)
        break
      }
    }

    callback(nil)
  }

}
