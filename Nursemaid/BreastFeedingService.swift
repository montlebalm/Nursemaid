import Alamofire
import Foundation

let SERVER = "http://cmontrois.local:3000"
let RESOURCE = SERVER + "/breastfeedings"

public class BreastFeedingService {

  let dateFormatter = NSDateFormatter()
  let user: User!

  init(user: User) {
    self.user = user

    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
  }

  func all(callback: (NSError?, [BreastFeeding]) -> ()) {
    Alamofire.request(.GET, RESOURCE)
      .authenticate(user: user.email, password: user.password)
      .responseJSON(handleMultiResponse(callback))
  }

  func create(startTime: NSDate, endTime: NSDate, lastSide: String, leftSeconds: Int, rightSeconds: Int, callback: (NSError?, BreastFeeding?) -> ()) {
    let params = [
      "userId": user.id,
      "startTime": dateFormatter.stringFromDate(startTime) as NSString,
      "endTime": dateFormatter.stringFromDate(endTime) as NSString,
      "lastSide": lastSide,
      "leftSeconds": leftSeconds,
      "rightSeconds": rightSeconds
    ]

    Alamofire.request(.POST, RESOURCE, parameters: params)
      .authenticate(user: user.email, password: user.password)
      .responseJSON(handleSingleResponse(callback))
  }

  func last(callback: (NSError?, BreastFeeding?) -> ()) {
    Alamofire.request(.GET, RESOURCE + "/last")
      .authenticate(user: user.email, password: user.password)
      .responseJSON(handleSingleResponse(callback))
  }

  func remove(id: String, callback: (NSError?) -> ()) {
    func handleResponse(req: NSURLRequest, res: NSHTTPURLResponse?, data: AnyObject?, err: NSError?) {
      callback(err)
    }

    let params = [
      "userId": user.id,
      "itemId": id
    ]

    Alamofire.request(.DELETE, RESOURCE + "/" + id, parameters: params)
      .authenticate(user: user.email, password: user.password)
      .responseJSON(handleResponse)
  }

  func toModel(raw: NSDictionary) -> BreastFeeding {
    let leftSeconds = (raw["leftSeconds"] as Int) ?? 0
    let rightSeconds = (raw["rightSeconds"] as Int) ?? 0
    let startTime = dateFormatter.dateFromString(raw["startTime"] as String)
    let endTime = dateFormatter.dateFromString(raw["endTime"] as String)

    var feeding = BreastFeeding()
    feeding.id = raw["id"] as? String
    feeding.userId = raw["userId"] as? String
    feeding.startTime = startTime
    feeding.endTime = endTime
    feeding.lastSide = raw["lastSide"] as? String
    feeding.leftSideSeconds = leftSeconds
    feeding.rightSideSeconds = rightSeconds
    return feeding
  }

  private func handleMultiResponse(callback: (NSError?, [BreastFeeding]) -> ())(req: NSURLRequest, res: NSHTTPURLResponse?, data: AnyObject?, err: NSError?) {
    var results: [BreastFeeding] = []
    
    if let raw = data as? [NSDictionary] {
      results = raw.map(toModel)
    }
    
    callback(err, results)
  }

  private func handleSingleResponse(callback: (NSError?, BreastFeeding?) -> ())(req: NSURLRequest, res: NSHTTPURLResponse?, data: AnyObject?, err: NSError?) {
    var result: BreastFeeding?
    
    if let raw = data as? NSDictionary {
      result = toModel(raw)
    }
    
    callback(err, result)
  }

}
