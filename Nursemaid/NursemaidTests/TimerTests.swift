import XCTest
import Nursemaid

class TimerTests: XCTestCase {

  // Elapsed

  func testElapsedStartAt0() {
    let timer = Timer()
    XCTAssertEqual(timer.elapsed, 0.0)
  }

  // Running

  func testRunningWhenStarted() {
    let expect = expectationWithDescription("Waiting for tick")

    let timer = Timer() { sec in
      expect.fulfill()
    }
    timer.delay = 0.1
    timer.start()

    waitForExpectationsWithTimeout(5) { err in
      XCTAssert(timer.running())
      timer.stop()
    }
  }

  func testNotRunningOnInit() {
    let timer = Timer()
    XCTAssertFalse(timer.running())
  }

  func testNotRunningWhenStopped() {
    let timer = Timer()
    timer.start()
    timer.stop()
    XCTAssertFalse(timer.running())
  }

  // Update

  func testUpdateIncrementsElapsed() {
    let expect = expectationWithDescription("Waiting for tick")

    let timer = Timer() { sec in
      expect.fulfill()
    }
    timer.delay = 0.1
    timer.start()

    waitForExpectationsWithTimeout(5) { err in
      timer.stop()
      XCTAssertEqual(timer.elapsed, 0.1)
    }
  }

}
