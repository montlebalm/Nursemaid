import Foundation

class AppearanceManager {

  var autoSelector: () -> (String?)
  var selectedName: String?
  var theme: AppTheme {
    var name = selectedName ?? autoSelector()
    return themes[name!]!
  }
  var themes = [String: AppTheme]()

  init(themes: [String: AppTheme], autoSelector: () -> (String?)) {
    self.themes = themes
    self.autoSelector = autoSelector
  }

  func set(name: String) {
    selectedName = name
  }

  func reset() {
    selectedName = nil
  }

}
