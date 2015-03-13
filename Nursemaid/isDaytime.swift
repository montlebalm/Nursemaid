import Foundation

func isDaytime(time: NSDate) -> Bool {
  let calendar = NSCalendar.currentCalendar()
  let components = calendar.components(.CalendarUnitHour, fromDate: time)
  return components.hour < 18
}
