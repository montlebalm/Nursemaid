import Foundation

class TimeIntervalFormatter {

  class func format(elapsed: Int) -> String {
    let minutes = Int(elapsed / 60)
    let seconds = Int(elapsed % 60)
    let secondsFormatted = seconds < 10 ? "0\(seconds)" : "\(seconds)"
    return "\(minutes):\(secondsFormatted)"
  }

}
