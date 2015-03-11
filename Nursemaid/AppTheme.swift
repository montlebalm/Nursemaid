import UIKit

protocol AppTheme {

  var BackgroundPrimary: UIColor { get }
  var BackgroundSecondary: UIColor { get }
  var BackgroundTertiary: UIColor { get }
  var HighlightPrimary: UIColor { get }
  var HighlightSecondary: UIColor { get }
  var HighlightTertiary: UIColor { get }
  var TextPrimary: UIColor { get }
  var TextSecondary: UIColor { get }
  var TextTertiary: UIColor { get }

  func activate()

  func deactivate()

}
