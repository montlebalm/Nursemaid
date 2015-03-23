import UIKit

class BottleViewController: UIViewController, Themeable {
  
  @IBOutlet weak var ouncesText: UILabel!
  @IBOutlet weak var ouncesSlider: UISlider!
  @IBOutlet weak var saveButton: UIBarButtonItem!
  @IBOutlet weak var resetButton: UIBarButtonItem!

  override func viewDidLoad() {
    super.viewDidLoad()

    resetView()
  }

  func resetView() {
  }

  // Protocol: Themeable

  func applyTheme() {}

  // IBActions

  @IBAction func ouncesChanged(sender: UISlider) {
    let value = roundf(ouncesSlider.value / 0.25) * 0.25;
    ouncesSlider.setValue(value, animated: false)

    ouncesText.text = "\(ouncesSlider.value)oz"
  }

  @IBAction func savePressed(sender: UIBarButtonItem) {
    let ounces = Double(ouncesSlider.value)
    BottleSvc.create(NSDate(), ounces: ounces) { err, bottlefeeding in }

    resetView()
  }

  @IBAction func resetPressed(sender: UIBarButtonItem) {
    resetView()
  }

}
