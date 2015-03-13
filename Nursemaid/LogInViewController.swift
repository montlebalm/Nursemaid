import UIKit

class LogInViewController: UIViewController, Themeable {

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

  @IBAction func facebookPressed(sender: UIButton) {
    // Skip login for local development
    if let userId = ENV["USER_ID"] as? String {
      let username = ENV["USER_EMAIL"] as String
      let password = ENV["USER_PASSWORD"] as String

      CurrentUser = User(id: userId, email: username, password: password)
    }
    
    performSegueWithIdentifier("goto_main", sender: self)
  }

}
