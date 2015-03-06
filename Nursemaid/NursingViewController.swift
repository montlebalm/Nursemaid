import CoreData
import UIKit

class NursingViewController: UIViewController {

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

  override func viewDidLoad() {
    super.viewDidLoad()

    styleViews()
    reset()
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidLoad()

    fetchData() {
      self.updatePreviousFeeding(self.previousFeeding)
    }
  }

  func fetchData(callback: () -> ()) {
    BreastFeedingSvc.last { err, result in
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

    if !saveButton.enabled {
      saveButton.enabled = true
    }

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

  func reset() {
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
      startTime!,
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

  // Styling

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
    toggleTimer(
      (rightBreastButton, rightTimer, "Right"),
      inactive: (leftBreastButton, leftTimer, "Left")
    )
  }

  @IBAction func savePressed(sender: UIBarButtonItem) {
    saveFeeding()
    reset()

    fetchData() {
      self.updatePreviousFeeding(self.previousFeeding)
    }
  }

  @IBAction func resetPressed(sender: UIBarButtonItem) {
    reset()
    updatePreviousFeeding(previousFeeding!)
  }

}
