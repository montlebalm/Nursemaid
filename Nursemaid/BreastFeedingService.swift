import Alamofire
import Foundation

public class BreastFeedingService {

  let baseUrl = SERVER + "/" + SERVER_VERSION + "/breastfeedings"
  let dateFormatter = NSDateFormatter()

  init() {
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
  }

  func all(user: User, callback: (NSError?, [BreastFeeding]) -> ()) {
    Alamofire.request(.GET, baseUrl)
      .authenticate(user: user.email, password: user.password)
      .responseJSON(handleMultiResponse(callback))
  }

  func create(user: User, startTime: NSDate, endTime: NSDate, lastSide: String, leftSeconds: Int, rightSeconds: Int, callback: (NSError?, BreastFeeding?) -> ()) {
    let params = [
      "userId": user.id,
      "startTime": dateFormatter.stringFromDate(startTime) as NSString,
      "endTime": dateFormatter.stringFromDate(endTime) as NSString,
      "lastSide": lastSide,
      "leftSeconds": leftSeconds,
      "rightSeconds": rightSeconds
    ]

    Alamofire.request(.POST, baseUrl, parameters: params)
      .authenticate(user: user.email, password: user.password)
      .responseJSON(handleSingleResponse(callback))
  }

  func last(user: User, callback: (NSError?, BreastFeeding?) -> ()) {
    Alamofire.request(.GET, baseUrl + "/last")
      .authenticate(user: user.email, password: user.password)
      .responseJSON(handleSingleResponse(callback))
  }

  func remove(user: User, id: String, callback: (NSError?) -> ()) {
    func handleResponse(req: NSURLRequest, res: NSHTTPURLResponse?, data: AnyObject?, err: NSError?) {
      callback(err)
    }

    let params = [
      "userId": user.id,
      "itemId": id
    ]

    Alamofire.request(.DELETE, baseUrl + "/" + id, parameters: params)
      .authenticate(user: user.email, password: user.password)
      .responseJSON(handleResponse)
  }

  func toModel(raw: NSDictionary) -> BreastFeeding {
    let leftSeconds = (raw["leftSeconds"] as? Int) ?? 0
    let rightSeconds = (raw["rightSeconds"] as? Int) ?? 0
    let startTime = dateFormatter.dateFromString(raw["startTime"] as String)
    let endTime = dateFormatter.dateFromString(raw["endTime"] as String)

    return BreastFeeding(
      id: raw["id"] as String,
      userId: raw["userId"] as String,
      startTime: startTime!,
      endTime: endTime!,
      leftSideSeconds: leftSeconds,
      rightSideSeconds: rightSeconds,
      lastSide: raw["lastSide"] as String
    )
  }

  private func handleMultiResponse(callback: (NSError?, [BreastFeeding]) -> ())(req: NSURLRequest, res: NSHTTPURLResponse?, data: AnyObject?, err: NSError?) {
    var error = err
    var results: [BreastFeeding] = []

    if error == nil && (200..<300) ~= res!.statusCode {
      error = NSError()
    }

    if error == nil {
      if let raw = data as? [NSDictionary] {
        results = raw.map(toModel)
      }
    }
    
    callback(error, results)
  }

  private func handleSingleResponse(callback: (NSError?, BreastFeeding?) -> ())(req: NSURLRequest, res: NSHTTPURLResponse?, data: AnyObject?, err: NSError?) {
    var error = err
    var result: BreastFeeding?

    if error == nil && (200..<300) ~= res!.statusCode {
      error = NSError()
    }

    if error == nil {
      if let raw = data as? NSDictionary {
        result = toModel(raw)
      }
    }

    callback(error, result)
  }

}
