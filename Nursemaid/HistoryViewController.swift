import CoreData
import UIKit

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, Themeable {

  var breastFeedings = [BreastFeeding]()
  let timeOfDayFormatter = NSDateFormatter()

  @IBOutlet weak var tableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()

    timeOfDayFormatter.dateStyle = .ShortStyle
    timeOfDayFormatter.timeStyle = .ShortStyle
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

    applyTheme()

    fetchData() {
      self.tableView.reloadData()
    }
  }

  func fetchData(callback: () -> ()) {
    BreastFeedingSvc.all(CurrentUser) { err, results in
      if err == nil {
        self.breastFeedings = results.sorted { $0.endTime.timeIntervalSince1970 > $1.endTime.timeIntervalSince1970 }
      }

      callback()
    }
  }

  // Styles

  func applyTheme() {
    let theme = Appearance.theme
  }

  // Protocol: UITableViewDataSource

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return breastFeedings.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let item = breastFeedings[indexPath.item] as BreastFeeding
    let leftTime = TimeIntervalFormatter.format(Int(item.leftSideSeconds))
    let rightTime = TimeIntervalFormatter.format(Int(item.rightSideSeconds))

    var cell = tableView.dequeueReusableCellWithIdentifier("historyTableCell") as HistoryTableCell
    cell.titleLabel.text = "(L) \(leftTime) (R) \(rightTime)"
    cell.dateLabel.text = timeOfDayFormatter.stringFromDate(item.endTime)
    return cell
  }

  func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }

  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
      let item = breastFeedings[indexPath.item]
      breastFeedings.removeAtIndex(indexPath.item)

      BreastFeedingSvc.remove(CurrentUser, id: item.id) { err in }

      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
  }

  // Protocol: UITableViewDelegate
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {}

}
