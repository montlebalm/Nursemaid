import XCTest
import Nursemaid

class TimerTests: XCTestCase {

  // Seconds

  func testSecondsStartAt0() {
    let t = Timer()
    XCTAssertEqual(t.seconds, 0)
  }

  // Running

  func testRunningOnInit() {
    let timer = Timer()
    XCTAssertFalse(timer.running())
  }

  func testRunningWhenStarted() {
    let expect = expectationWithDescription("Waiting for tick")

    let timer = Timer() {
      expect.fulfill()
    }
    timer.start()

    waitForExpectationsWithTimeout(5) { err in
      XCTAssert(timer.running())
      timer.stop()
    }
  }

  func testRunningWhenStopped() {
    let expect = expectationWithDescription("Waiting for tick")
    let timer = Timer() {
      expect.fulfill()
    }
    timer.start()

    waitForExpectationsWithTimeout(5) { err in
      timer.stop()
      XCTAssertFalse(timer.running())
    }
  }

  // Update

  func testUpdateIncrementsSeconds() {
    let expect = expectationWithDescription("Waiting for tick")

    let timer = Timer() {
      expect.fulfill()
    }
    timer.start()

    waitForExpectationsWithTimeout(5) { err in
      timer.stop()
      XCTAssertEqual(timer.seconds, 1)
    }
  }

}