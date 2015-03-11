import UIKit

struct NightTheme: AppTheme {

  var BackgroundPrimary = Colors.BlackDark
  var BackgroundSecondary = Colors.BlackMedium
  var BackgroundTertiary = Colors.BlackLight
  var HighlightPrimary = Colors.BlueDark
  var HighlightSecondary = Colors.BlueMedium
  var HighlightTertiary = Colors.BlueLight
  var TextPrimary = Colors.WhiteLight
  var TextSecondary = Colors.WhiteMedium
  var TextTertiary = Colors.BlackLight

  init() {}

  func activate() {
    let app = UIApplication.sharedApplication()
    app.statusBarStyle = UIStatusBarStyle.BlackOpaque

    let tab = UITabBar.appearance()
    tab.barTintColor = BackgroundSecondary
    tab.selectedImageTintColor = HighlightTertiary
  }

  func deactivate() {}

}
