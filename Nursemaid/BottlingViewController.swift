import CoreData
import UIKit

class BottlingViewController: UIViewController {

  // @IBOutlet

  @IBOutlet weak var contentsLabel: UILabel!
  @IBOutlet weak var quantityLabel: UILabel!

  @IBOutlet weak var resetButton: UIBarButtonItem!
  @IBOutlet weak var saveButton: UIBarButtonItem!

  override func viewDidLoad() {
    super.viewDidLoad()

    styleViews()
    reset()
  }

  func reset() {
    contentsLabel.text = "--"
    quantityLabel.text = "--"

    saveButton.enabled = false
  }

  // Styling

  func styleViews() {
  }

  // @IBActions

  @IBAction func savePressed(sender: UIBarButtonItem) {
  }

  @IBAction func resetPressed(sender: UIBarButtonItem) {
  }

}
