import UIKit

let isoDateFormatter = NSDateFormatter()
isoDateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")

isoDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
isoDateFormatter.dateFromString("2015-03-06T08:45:46-07:00")

let isoExample1 = "1994-11-05T08:15:30-05:00"
let isoExample2 = "1994-11-05T13:15:30Z"