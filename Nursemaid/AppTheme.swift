import UIKit

protocol AppTheme {

  var BackgroundPrimary: UIColor { get }
  var BackgroundSecondary: UIColor { get }
  var HighlightPrimary: UIColor { get }
  var HighlightSecondary: UIColor { get }
  var TextPrimary: UIColor { get }
  var TextSecondary: UIColor { get }
  var StatusBarStyle: UIStatusBarStyle { get }

  func activate()

  func deactivate()

}
