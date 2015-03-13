import UIKit

class HomeViewController: UIViewController, Themeable {

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

    applyTheme()
  }

  // Protocol: Themeable
  
  func applyTheme() {
    let theme = Appearance.theme
  }

  // IBActions

  @IBAction func dayThemePressed(sender: UIButton) {
    Appearance.set("day")
    applyTheme()
  }

  @IBAction func nightThemePressed(sender: UIButton) {
    Appearance.set("night")
    applyTheme()
  }

}
