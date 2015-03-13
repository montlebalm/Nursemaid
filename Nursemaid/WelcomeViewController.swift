import UIKit

class WelcomeViewController: UIViewController {

  @IBOutlet weak var titleLabel: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

    if !isFirstLoad {
      performSegueWithIdentifier("goto_login", sender: self)
    } else if CurrentUser != nil {
      performSegueWithIdentifier("goto_main", sender: self)
    }
  }

  @IBAction func skipPressed(sender: UIButton) {
    performSegueWithIdentifier("goto_login", sender: self)
  }

}
