import UIKit

struct NightTheme: AppTheme {

  var BackgroundPrimary = Colors.BlackDark
  var BackgroundSecondary = Colors.BlackMedium
  var HighlightPrimary = Colors.BlueLight
  var HighlightSecondary = Colors.BlueMedium
  var TextPrimary = Colors.WhiteLight
  var TextSecondary = Colors.WhiteMedium
  var StatusBarStyle = UIStatusBarStyle.LightContent

  init() {}

  func activate() {
    let nav = UINavigationBar.appearance()
    nav.tintColor = HighlightPrimary
    nav.barTintColor = BackgroundPrimary
    nav.titleTextAttributes = [NSForegroundColorAttributeName: TextPrimary]

    let tab = UITabBar.appearance()
    tab.barTintColor = BackgroundPrimary
    tab.selectedImageTintColor = HighlightSecondary

    let label = UILabel.appearance()
    label.textColor = UIColor.whiteColor()

    let button = UIButton.appearance()
    button.tintColor = HighlightPrimary
    button.layer.borderColor = HighlightPrimary.CGColor
  }

  func deactivate() {}

}
