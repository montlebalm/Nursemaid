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

struct Colors {
  
  static let BlackLight = colorFromHex("555555")
  static let BlackMedium = colorFromHex("333333")
  static let BlackDark = colorFromHex("1a1a1a")

  static let PinkLight = colorFromHex("fb806d")
  static let PinkMedium = colorFromHex("f6775b")
  static let PinkDark = colorFromHex("915656")

  static let BlueLight = colorFromHex("9cc9f9")
  static let BlueMedium = colorFromHex("007aff")
  static let BlueDark = colorFromHex("5984b3")

  static let WhiteLight = colorFromHex("f4f4f4")
  static let WhiteMedium = colorFromHex("b3b3b3")
  static let WhiteDark = colorFromHex("cccccc")

}
