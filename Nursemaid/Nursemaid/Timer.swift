import Foundation

public class Timer {

  public var seconds = 0

  var timer: NSTimer
  var onTick: () -> ()

  public init(update: (() -> ())? = nil) {
    onTick = update != nil ? update! : {}
    timer = NSTimer()
  }

  public func start() {
    stop()
    timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "tick", userInfo: nil, repeats: true)
  }

  public func stop() {
    timer.invalidate()
  }

  public func running() -> Bool {
    return timer.valid
  }

  @objc func tick() {
    seconds += 1
    onTick()
  }

  deinit {
    stop()
  }

}
