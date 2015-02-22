import Foundation

public class Timer {

  /// The delay between ticks. Defaults to 1.0
  public var delay = 1.0

  /// The amount of time that has passed since the timer started
  public var elapsed = 0.0

  /// The function that runs on every update
  var tick: ((Double) -> ())?

  /// Internal timer
  var timer: NSTimer?

  public init(onTick: ((Double) -> ())? = nil) {
    tick = onTick
  }

  /// Starts the timer
  public func start() {
    stop()

    timer = NSTimer.scheduledTimerWithTimeInterval(
      NSTimeInterval(delay),
      target: self,
      selector: "onTick",
      userInfo: nil,
      repeats: true
    )
  }

  /// Stops the timer
  public func stop() {
    timer?.invalidate()
  }

  /// Indicates whether the timer is currently running
  /// :return: true if the the timer is running
  public func running() -> Bool {
    return timer?.valid ?? false
  }

  @objc func onTick() {
    elapsed += delay
    tick?(elapsed)
  }

  deinit {
    stop()
  }

}
