import UIKit

let isFirstLoad = true

class WelcomeViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    // Skip login for development
    if let userId = ENV["USER_ID"] as? String {
      let username = ENV["USER_EMAIL"] as String
      let password = ENV["USER_PASSWORD"] as String

      CurrentUser = User(id: userId, email: username, password: password)
    }
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
    performSegueWithIdentifier("goto_main", sender: self)
  }

}
