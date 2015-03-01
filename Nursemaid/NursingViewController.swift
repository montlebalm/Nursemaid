import CoreData
import UIKit

class FirstViewController: UIViewController {

  let context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
  var currentTimer: Timer?
  var leftTimer: Timer!
  var rightTimer: Timer!
  var startTime: NSDate?

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

    styleViews()
    reset()
  }

  func updateElapsedLabel(label: UILabel)(elapsed: Double) {
    label.text = TimeIntervalFormatter.format(elapsed)
    totalElapsedLabel.text = TimeIntervalFormatter.format(leftTimer.elapsed + rightTimer.elapsed)
  }

  func toggleTimer(
    active: (button: UIButton, timer: Timer, label: String),
    inactive: (button: UIButton, timer: Timer, label: String)
  ) {
    if startTime == nil {
      startTime = NSDate()
    }

    if !saveButton.enabled {
      saveButton.enabled = true
    }

    currentTimer = active.timer
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
    leftTimer?.stop()
    rightTimer?.stop()
    leftTimer = Timer(updateElapsedLabel(leftElapsedLabel))
    rightTimer = Timer(updateElapsedLabel(rightElapsedLabel))

    leftElapsedLabel.text = TimeIntervalFormatter.format(0)
    rightElapsedLabel.text = TimeIntervalFormatter.format(0)
    totalElapsedLabel.text = TimeIntervalFormatter.format(0)

    lastSideLabel.text = "--"

    saveButton.enabled = false
  }

  func saveFeeding() {
    let lastSide = currentTimer! === leftTimer ? "l" : "r"

    BreastFeeding.createInContext(
      context!,
      leftSeconds: Int(leftTimer.elapsed),
      rightSeconds: Int(rightTimer.elapsed),
      lastSide: lastSide,
      startTime: startTime!,
      endTime: NSDate()
    )
  }

  func saveContext() {
    var error : NSError?

    if (context!.save(&error)) {
      println(error?.localizedDescription)
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
    saveContext()
    reset()
  }

  @IBAction func resetPressed(sender: UIBarButtonItem) {
    reset()
  }

}
