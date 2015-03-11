import UIKit

class LogInViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  @IBAction func facebookPressed(sender: UIButton) {
    performSegueWithIdentifier("goto_main", sender: self)
  }

}
