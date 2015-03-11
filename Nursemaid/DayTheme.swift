import UIKit

struct DayTheme: AppTheme {

  var BackgroundPrimary = Colors.WhiteLight
  var BackgroundSecondary = Colors.WhiteMedium
  var BackgroundTertiary = Colors.WhiteDark
  var HighlightPrimary = Colors.BlueMedium
  var HighlightSecondary = Colors.BlueLight
  var HighlightTertiary = Colors.BlueDark
  var TextPrimary = Colors.BlackDark
  var TextSecondary = Colors.BlackMedium
  var TextTertiary = Colors.WhiteDark

  init() {
    let app = UIApplication.sharedApplication()
    app.statusBarStyle = UIStatusBarStyle.LightContent

    let tab = UITabBar.appearance()
    tab.barTintColor = BackgroundSecondary
    tab.selectedImageTintColor = HighlightTertiary
  }

}
