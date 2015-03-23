import Foundation

public class BottleService {

  var fakeIdCtr = 0
  
  var data: [Bottlefeeding] = []

  init() {}

  func all(callback: (NSError?, [Bottlefeeding]) -> ()) {
    callback(nil, data)
  }

  func create(endTime: NSDate, ounces: Double, callback: (NSError?, Bottlefeeding?) -> ()) {
    data.append(Bottlefeeding(
      id: String(++fakeIdCtr),
      userId: "1",
      endTime: endTime,
      ounces: ounces
    ))
    last(callback)
  }

  func last(callback: (NSError?, Bottlefeeding?) -> ()) {
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
