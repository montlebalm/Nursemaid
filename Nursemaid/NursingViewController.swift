import UIKit

class FirstViewController: UIViewController {

  var leftTimer: Timer!
  var rightTimer: Timer!
  var session: BreastFeeding!
  let timeOfDayFormatter = NSDateFormatter()

  @IBOutlet weak var leftBreastButton: UIButton!
  @IBOutlet weak var leftElapsedLabel: UILabel!
  @IBOutlet weak var rightBreastButton: UIButton!
  @IBOutlet weak var rightElapsedLabel: UILabel!
  @IBOutlet weak var totalElapsedLabel: UILabel!

  @IBOutlet weak var lastSideLabel: UILabel!
  @IBOutlet weak var lastLeftElapsedLabel: UILabel!
  @IBOutlet weak var lastRightElapsedLabel: UILabel!

  @IBOutlet weak var resetButton: UIBarButtonItem!
  @IBOutlet weak var saveButton: UIBarButtonItem!

  override func viewDidLoad() {
    super.viewDidLoad()

    timeOfDayFormatter.timeStyle = .ShortStyle

    styleViews()
    reset()
  }

  func updateElapsedLabel(label: UILabel)(elapsed: Double) {
    label.text = formatElapsed(elapsed)
    totalElapsedLabel.text = formatElapsed(leftTimer.elapsed + rightTimer.elapsed)
  }

  func toggleTimer(
    active: (button: UIButton, timer: Timer, label: String),
    inactive: (button: UIButton, timer: Timer, label: String)
  ) {
    if session.startTime == nil {
      session.startTime = NSDate()
    }

    if !saveButton.enabled {
      saveButton.enabled = true
    }

    toggleBreastButton(active, inactive: inactive)
  }

  func toggleBreastButton(
    active: (button: UIButton, timer: Timer, label: String),
    inactive: (button: UIButton, timer: Timer, label: String)
  ) {
    if active.timer.running() {
      active.timer.stop()
      active.button.setTitle("Nurse on " + active.label, forState: UIControlState.Normal)
    } else {
      active.timer.start()
      active.button.setTitle("Stop " + active.label, forState: UIControlState.Normal)

      inactive.timer.stop()
      inactive.button.setTitle("Nurse on " + inactive.label, forState: UIControlState.Normal)
    }
  }

  func reset() {
    session = BreastFeeding()

    leftTimer?.stop()
    rightTimer?.stop()
    leftTimer = Timer(updateElapsedLabel(leftElapsedLabel))
    rightTimer = Timer(updateElapsedLabel(rightElapsedLabel))

    leftElapsedLabel.text = formatElapsed(0)
    rightElapsedLabel.text = formatElapsed(0)
    totalElapsedLabel.text = formatElapsed(0)

    lastSideLabel.text = "--"

    saveButton.enabled = false
  }

  // Styling

  func formatElapsed(elapsed: Double) -> String {
    let minutes = Int(elapsed / 60)
    let seconds = Int(elapsed % 60)
    let secondsFormatted = seconds < 10 ? "0\(seconds)" : "\(seconds)"
    return "\(minutes):\(secondsFormatted)"
  }

  func styleViews() {
    styleBreastButton(leftBreastButton)
    styleBreastButton(rightBreastButton)
  }

  func styleBreastButton(btn: UIButton) {
    btn.layer.borderColor = btn.tintColor?.CGColor
    btn.layer.borderWidth = 1
    btn.layer.cornerRadius = btn.layer.frame.width / 2
  }

  // @IBActions

  @IBAction func leftBreastPressed(sender: UIButton) {
    toggleTimer(
      (leftBreastButton, leftTimer, "Left"),
      inactive: (rightBreastButton, rightTimer, "Right")
    )
  }

  @IBAction func rightBreastPressed(sender: UIButton) {
    toggleBreastButton(
      (rightBreastButton, rightTimer, "Right"),
      inactive: (leftBreastButton, leftTimer, "Left")
    )
  }

  @IBAction func savePressed(sender: UIBarButtonItem) {
    leftTimer?.stop()
    rightTimer?.stop()

    session.endTime = NSDate()
    session.leftElapsed = NSTimeInterval(leftTimer.elapsed)
    session.rightElapsed = NSTimeInterval(rightTimer.elapsed)

    // TODO: Save session

    reset()
  }

  @IBAction func resetPressed(sender: UIBarButtonItem) {
    reset()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

}
