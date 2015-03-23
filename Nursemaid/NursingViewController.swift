import UIKit

class NursingViewController: UIViewController, Themeable {

  var currentTimer: Timer?
  var leftTimer: Timer!
  var previousFeeding: Breastfeeding?
  var rightTimer: Timer!

  @IBOutlet weak var leftBreastButton: UIButton!
  @IBOutlet weak var leftElapsedLabel: UILabel!
  @IBOutlet weak var rightBreastButton: UIButton!
  @IBOutlet weak var rightElapsedLabel: UILabel!

  @IBOutlet weak var lastLastSideLabel: UILabel!
  @IBOutlet weak var lastLeftElapsedLabel: UILabel!
  @IBOutlet weak var lastRightElapsedLabel: UILabel!

  @IBOutlet weak var resetButton: UIBarButtonItem!
  @IBOutlet weak var saveButton: UIBarButtonItem!

  // For styling only
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
    BreastSvc.last() { err, result in
      if err == nil {
        self.previousFeeding = result
      }

      callback()
    }
  }

  func updateElapsedLabel(label: UILabel)(elapsed: Double) {
    label.text = TimeIntervalFormatter.format(Int(elapsed))
  }

  func updatePreviousFeeding(previousFeeding: Breastfeeding?) {
    if let feeding = previousFeeding {
      lastLastSideLabel.text = feeding.lastSide == "l" ? "Left" : "Right"
      lastLeftElapsedLabel.text = TimeIntervalFormatter.format(feeding.leftSideSeconds)
      lastRightElapsedLabel.text = TimeIntervalFormatter.format(feeding.rightSideSeconds)
    } else {
      resetPreviousFeeding()
    }
  }

  func toggleTimer(active: (button: UIButton, timer: Timer, label: String), inactive: (button: UIButton, timer: Timer, label: String)) {
    resetButton.enabled = true
    saveButton.enabled = true

    currentTimer = active.timer
    toggleBreastButton(active, inactive: inactive)
  }

  func toggleBreastButton(active: (button: UIButton, timer: Timer, label: String), inactive: (button: UIButton, timer: Timer, label: String)) {
    if active.timer.running() {
      active.timer.stop()
      active.button.setTitle("Start", forState: UIControlState.Normal)
    } else {
      active.timer.start()
      active.button.setTitle("Stop", forState: UIControlState.Normal)

      inactive.timer.stop()
      inactive.button.setTitle("Start", forState: UIControlState.Normal)
    }
  }

  func resetView() {
    leftTimer?.stop()
    rightTimer?.stop()
    leftTimer = Timer(updateElapsedLabel(leftElapsedLabel))
    rightTimer = Timer(updateElapsedLabel(rightElapsedLabel))

    leftBreastButton.setTitle("Start", forState: UIControlState.Normal)
    rightBreastButton.setTitle("Start", forState: UIControlState.Normal)
    leftBreastButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 15.0, 0.0)
    rightBreastButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 15.0, 0.0)

    leftElapsedLabel.text = TimeIntervalFormatter.format(0)
    rightElapsedLabel.text = TimeIntervalFormatter.format(0)

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

    BreastSvc.create(
      NSDate(),
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
    return Theme.StatusBarStyle
  }

  // Protocol: Themeable

  func applyTheme() {
    previousSectionView.backgroundColor = Theme.BackgroundSecondary
    
    lastLastSideLabel.textColor = Theme.TextSecondary
    lastLeftElapsedLabel.textColor = Theme.TextSecondary
    lastRightElapsedLabel.textColor = Theme.TextSecondary
    previousSectionLabel.textColor = Theme.TextSecondary
    
    leftBreastButton.layer.borderColor = Theme.HighlightPrimary.CGColor
    rightBreastButton.layer.borderColor = Theme.HighlightPrimary.CGColor
    
    view.backgroundColor = Theme.BackgroundPrimary
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
