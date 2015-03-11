import UIKit

class HomeViewController: UIViewController, Themeable {

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

    applyTheme()
  }

  func applyTheme() {
    let theme = Appearance.theme
  }

}
