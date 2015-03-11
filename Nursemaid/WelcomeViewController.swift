import UIKit

class WelcomeViewController: UIViewController, Themeable {

  @IBOutlet weak var titleLabel: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

    applyTheme()

    if !isFirstLoad {
      performSegueWithIdentifier("goto_login", sender: self)
    } else if CurrentUser != nil {
      performSegueWithIdentifier("goto_main", sender: self)
    }
  }

  func applyTheme() {
    let theme = Appearance.theme
  }

  @IBAction func skipPressed(sender: UIButton) {
    performSegueWithIdentifier("goto_login", sender: self)
  }

}
