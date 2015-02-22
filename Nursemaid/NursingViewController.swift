import UIKit

class FirstViewController: UIViewController {

  var leftTimer: Timer!
  var rightTimer: Timer!
  var session: BreastFeeding!
  let sessionDateFormatter = NSDateFormatter()

  @IBOutlet weak var leftBreastButton: UIButton!
  @IBOutlet weak var leftElapsedLabel: UILabel!
  @IBOutlet weak var rightBreastButton: UIButton!
  @IBOutlet weak var rightElapsedLabel: UILabel!

  @IBOutlet weak var sessionStartLabel: UILabel!
  @IBOutlet weak var totalElapsedLabel: UILabel!

  @IBOutlet weak var lastEndTimeLabel: UILabel!
  @IBOutlet weak var lastSideLabel: UILabel!
  @IBOutlet weak var lastTotalTimeLabel: UILabel!

  @IBOutlet weak var resetButton: UIBarButtonItem!
  @IBOutlet weak var saveButton: UIBarButtonItem!

  override func viewDidLoad() {
    super.viewDidLoad()

    sessionDateFormatter.timeStyle = .ShortStyle

    styleViews()
    reset()
  }

  func updateElapsedLabel(label: UILabel)(elapsed: Double) {
    label.text = formatElapsed(elapsed)
    totalElapsedLabel.text = formatElapsed(leftTimer.elapsed + rightTimer.elapsed)
  }

  func toggleBreastButton(
    active: (button: UIButton, timer: Timer, label: String),
    inactive: (button: UIButton, timer: Timer, label: String)
  ) {
    if session.startTime == nil {
      session.startTime = NSDate()
      sessionStartLabel.text = sessionDateFormatter.stringFromDate(session.startTime!)
    }

    if !saveButton.enabled {
      saveButton.enabled = true
    }

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
    sessionStartLabel.text = "--"

    lastEndTimeLabel.text = "--"
    lastSideLabel.text = "--"
    lastTotalTimeLabel.text = "0:00"

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
    toggleBreastButton(
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
    session.leftBreastSeconds = Int(leftTimer.elapsed)
    session.rightBreastSeconds = Int(rightTimer.elapsed)

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
