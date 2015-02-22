import UIKit

class FirstViewController: UIViewController {

  @IBOutlet weak var leftBreastButton: UIButton!
  @IBOutlet weak var leftElapsedLabel: UILabel!
  @IBOutlet weak var rightBreastButton: UIButton!
  @IBOutlet weak var rightElapsedLabel: UILabel!
  @IBOutlet weak var totalElapsedLabel: UILabel!
  @IBOutlet weak var sessionStartLabel: UILabel!
  @IBOutlet weak var todayLeftElapsed: UILabel!
  @IBOutlet weak var todayRightElapsed: UILabel!
  @IBOutlet weak var saveButton: UIBarButtonItem!
  @IBOutlet weak var resetButton: UIBarButtonItem!

  var leftTimer: Timer!
  var rightTimer: Timer!
  var session: BreastFeeding!
  let sessionDateFormatter = NSDateFormatter()

  override func viewDidLoad() {
    super.viewDidLoad()

    sessionDateFormatter.timeStyle = .MediumStyle

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

    if saveButton.enabled == false {
      saveButton.enabled = true
    }

    if active.timer.running() {
      active.timer.stop()
      active.button.setTitle("Start " + active.label, forState: UIControlState.Normal)
    } else {
      active.timer.start()
      active.button.setTitle("Stop " + active.label, forState: UIControlState.Normal)

      inactive.timer.stop()
      inactive.button.setTitle("Start " + inactive.label, forState: UIControlState.Normal)
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

    // Save session

    reset()
  }

  @IBAction func resetPressed(sender: UIBarButtonItem) {
    reset()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

}
