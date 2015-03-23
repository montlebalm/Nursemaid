import Parse
import UIKit

class HomeViewController: UIViewController, Themeable {

  @IBOutlet weak var welcomeLabel: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()

    if CurrentUser == nil || !CurrentUser!.isAuthenticated() {
      gotoLogin()
    }

    welcomeLabel.text = CurrentUser?.username
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

    applyTheme()
  }

  func gotoLogin() {
    presentViewController(getController("Login", "Login"), animated: true, completion: nil)
  }

  // Protocol: Themeable
  
  func applyTheme() {}

  // IBActions

  @IBAction func signOutPressed(sender: AnyObject) {
    PFUser.logOut()
    gotoLogin()
  }

}
