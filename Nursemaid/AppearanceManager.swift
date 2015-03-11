import Foundation

class AppearanceManager {

  var autoSelector: () -> (String?)
  var lastSelectedName: String?
  var selectedName: String?
  var theme: AppTheme {
    var name = selectedName ?? autoSelector()
    var active = themes[name!]

    if name != lastSelectedName {
      if lastSelectedName != nil {
        themes[lastSelectedName!]?.deactivate()
      }

      themes[name!]?.activate()
    }

    return themes[name!]!
  }
  var themes = [String: AppTheme]()

  init(themes: [String: AppTheme], autoSelector: () -> (String?)) {
    self.themes = themes
    self.autoSelector = autoSelector
  }

  func set(name: String) {
    lastSelectedName = selectedName
    selectedName = name
  }

  func reset() {
    selectedName = nil
  }

}
