import UIKit

class NursingViewController: UIViewController, Themeable {

  var currentTimer: Timer?
  var leftTimer: Timer!
  var previousFeeding: BreastFeeding?
  var rightTimer: Timer!
  var startTime: NSDate?

  @IBOutlet weak var leftBreastButton: UIButton!
  @IBOutlet weak var leftElapsedLabel: UILabel!
  @IBOutlet weak var rightBreastButton: UIButton!
  @IBOutlet weak var rightElapsedLabel: UILabel!
  @IBOutlet weak var totalElapsedLabel: UILabel!
  @IBOutlet weak var lastSideLabel: UILabel!

  @IBOutlet weak var lastLastSideLabel: UILabel!
  @IBOutlet weak var lastLeftElapsedLabel: UILabel!
  @IBOutlet weak var lastRightElapsedLabel: UILabel!

  @IBOutlet weak var resetButton: UIBarButtonItem!
  @IBOutlet weak var saveButton: UIBarButtonItem!

  // For styling only
  @IBOutlet weak var currentSectionLabel: UILabel!
  @IBOutlet weak var currentSectionView: UIView!
  @IBOutlet weak var previousSectionLabel: UILabel!
  @IBOutlet weak var previousSectionView: UIView!

  override func viewDidLoad() {
    super.viewDidLoad()

    styleViews()
    resetView()
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

    applyTheme()

    fetchData() {
      self.updatePreviousFeeding(self.previousFeeding)
    }
  }

  func fetchData(callback: () -> ()) {
    BreastFeedingSvc.last(CurrentUser) { err, result in
      if err == nil {
        self.previousFeeding = result
      }

      callback()
    }
  }

  func updateElapsedLabel(label: UILabel)(elapsed: Double) {
    label.text = TimeIntervalFormatter.format(Int(elapsed))
    totalElapsedLabel.text = TimeIntervalFormatter.format(Int(leftTimer.elapsed + rightTimer.elapsed))
  }

  func updatePreviousFeeding(previousFeeding: BreastFeeding?) {
    if let feeding = previousFeeding {
      lastLastSideLabel.text = feeding.lastSide == "l" ? "Left" : "Right"
      lastLeftElapsedLabel.text = TimeIntervalFormatter.format(feeding.leftSideSeconds)
      lastRightElapsedLabel.text = TimeIntervalFormatter.format(feeding.rightSideSeconds)
    } else {
      resetPreviousFeeding()
    }
  }

  func toggleTimer(active: (button: UIButton, timer: Timer, label: String), inactive: (button: UIButton, timer: Timer, label: String)) {
    if startTime == nil {
      startTime = NSDate()
    }

    resetButton.enabled = true
    saveButton.enabled = true

    currentTimer = active.timer
    lastSideLabel.text = currentTimer! === leftTimer ? "Left" : "Right"
    toggleBreastButton(active, inactive: inactive)
  }

  func toggleBreastButton(active: (button: UIButton, timer: Timer, label: String), inactive: (button: UIButton, timer: Timer, label: String)) {
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

  func resetView() {
    leftTimer?.stop()
    rightTimer?.stop()
    leftTimer = Timer(updateElapsedLabel(leftElapsedLabel))
    rightTimer = Timer(updateElapsedLabel(rightElapsedLabel))

    leftBreastButton.setTitle("Nurse on Left", forState: UIControlState.Normal)
    rightBreastButton.setTitle("Nurse on Right", forState: UIControlState.Normal)

    leftElapsedLabel.text = TimeIntervalFormatter.format(0)
    rightElapsedLabel.text = TimeIntervalFormatter.format(0)
    totalElapsedLabel.text = TimeIntervalFormatter.format(0)
    lastSideLabel.text = "--"

    resetPreviousFeeding()

    resetButton.enabled = false
    saveButton.enabled = false
  }

  func resetPreviousFeeding() {
    lastLeftElapsedLabel.text = TimeIntervalFormatter.format(0)
    lastRightElapsedLabel.text = TimeIntervalFormatter.format(0)
    lastLastSideLabel.text = "--"
  }

  func saveFeeding() {
    let lastSide = currentTimer! === leftTimer ? "l" : "r"

    BreastFeedingSvc.create(
      CurrentUser,
      startTime: startTime!,
      endTime: NSDate(),
      lastSide: lastSide,
      leftSeconds: Int(leftTimer.elapsed),
      rightSeconds: Int(rightTimer.elapsed)
    ) { err, feeding in
      if err == nil {
        self.previousFeeding = feeding
        self.updatePreviousFeeding(feeding)
      }
    }
  }

  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return Appearance.theme.StatusBarStyle
  }

  // Protocol: Themeable

  func applyTheme() {
    let theme = Appearance.theme

    totalElapsedLabel.textColor = theme.TextSecondary
    lastSideLabel.textColor = theme.TextSecondary
    currentSectionLabel.textColor = theme.TextSecondary

    currentSectionView.backgroundColor = theme.BackgroundSecondary
    previousSectionView.backgroundColor = theme.BackgroundSecondary

    lastLastSideLabel.textColor = theme.TextSecondary
    lastLeftElapsedLabel.textColor = theme.TextSecondary
    lastRightElapsedLabel.textColor = theme.TextSecondary
    previousSectionLabel.textColor = theme.TextSecondary

    leftBreastButton.layer.borderColor = theme.HighlightPrimary.CGColor
    rightBreastButton.layer.borderColor = theme.HighlightPrimary.CGColor

    view.backgroundColor = theme.BackgroundPrimary
  }

  func styleViews() {
    styleBreastButton(leftBreastButton)
    styleBreastButton(rightBreastButton)
  }

  func styleBreastButton(btn: UIButton) {
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
    toggleTimer(
      (rightBreastButton, rightTimer, "Right"),
      inactive: (leftBreastButton, leftTimer, "Left")
    )
  }

  @IBAction func savePressed(sender: UIBarButtonItem) {
    saveFeeding()
    resetView()

    fetchData() {
      self.updatePreviousFeeding(self.previousFeeding)
    }
  }

  @IBAction func resetPressed(sender: UIBarButtonItem) {
    resetView()
    updatePreviousFeeding(previousFeeding)
  }

}
