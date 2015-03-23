import Parse
import UIKit

class LogInViewController: UIViewController, Themeable {

  let whitespace = NSCharacterSet.whitespaceCharacterSet()

  @IBOutlet weak var usernameText: UITextField!
  @IBOutlet weak var passwordText: UITextField!
  @IBOutlet weak var messageLabel: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()

    resetView()
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

    applyTheme()
  }

  func logIn(username: String, password: String, savePassword: Bool) {
    let usernameClean = username.stringByTrimmingCharactersInSet(whitespace)

    UserSvc.login(usernameClean, password: password) { err in
      if err != nil {
        return self.messageLabel.text = "Invalid username/password combination"
      }

      self.presentViewController(getController("Main", "TabBar"), animated: true, completion: nil)
    }
  }

  func resetView() {
    messageLabel.text = ""
  }

  // Protocol: Themeable

  func applyTheme() {}

  // IBActions

  @IBAction func logInPressed(sender: UIButton) {
    if !usernameText.text.isEmpty && !passwordText.text.isEmpty {
      logIn(usernameText.text, password: passwordText.text, savePassword: false)
    } else {
      messageLabel.text = "Both fields are required"
    }
  }
  
}
