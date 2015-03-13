import UIKit

func colorFromHex(hex: String) -> UIColor {
  var cString = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString

  if (cString.hasPrefix("#")) {
    cString = cString.substringFromIndex(advance(cString.startIndex, 1))
  }

  if (countElements(cString) != 6) {
    return UIColor.grayColor()
  }

  var rgbValue:UInt32 = 0
  NSScanner(string: cString).scanHexInt(&rgbValue)
  let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
  let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
  let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

  return UIColor(red: red, green: green, blue: blue, alpha: CGFloat(1.0))
}
