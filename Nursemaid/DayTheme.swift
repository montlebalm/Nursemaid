import UIKit

struct DayTheme: AppTheme {

  var BackgroundPrimary = UIColor.whiteColor()
  var BackgroundSecondary = Colors.WhiteLight
  var BackgroundTertiary = Colors.WhiteMedium
  var HighlightPrimary = Colors.BlueMedium
  var HighlightSecondary = Colors.BlueLight
  var HighlightTertiary = Colors.BlueDark
  var TextPrimary = Colors.BlackDark
  var TextSecondary = Colors.BlackMedium
  var TextTertiary = Colors.WhiteDark
  var StatusBarStyle = UIStatusBarStyle.BlackOpaque

  init() {}

  func activate() {
    let app = UIApplication.sharedApplication()
    app.statusBarStyle = UIStatusBarStyle.LightContent

    let tab = UITabBar.appearance()
    tab.barTintColor = BackgroundSecondary
    tab.selectedImageTintColor = HighlightTertiary
  }

  func deactivate() {}

}
