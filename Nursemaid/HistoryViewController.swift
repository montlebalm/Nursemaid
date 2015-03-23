import UIKit

struct HistoryItem {
  var id: String
  var label: String
  var date: NSDate
  var type: String
}

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, Themeable {

  var items: [HistoryItem] = []
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
    items = []
    var remaining = 2

    BreastSvc.all { err, breastfeedings in
      self.items += breastfeedings.map(self.breastfeedingToItem)

      if --remaining == 0 {
        callback()
      }
    }

    BottleSvc.all { err, bottlefeedings in
      self.items += bottlefeedings.map(self.bottlefeedingToItem)

      if --remaining == 0 {
        callback()
      }
    }
  }

  func breastfeedingToItem(feeding: Breastfeeding) -> HistoryItem {
    let leftTime = TimeIntervalFormatter.format(Int(feeding.leftSideSeconds))
    let rightTime = TimeIntervalFormatter.format(Int(feeding.rightSideSeconds))
    let label = "(L) \(leftTime) (R) \(rightTime)"
    return HistoryItem(id: feeding.id, label: label, date: feeding.endTime, type: "breast")
  }

  func bottlefeedingToItem(feeding: Bottlefeeding) -> HistoryItem {
    let label = "\(feeding.ounces)oz"
    return HistoryItem(id: feeding.id, label: label, date: feeding.endTime, type: "bottle")
  }

  // Protocol: Themeable

  func applyTheme() {}

  // Protocol: UITableViewDataSource

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let item = items[indexPath.item] as HistoryItem

    var cell = tableView.dequeueReusableCellWithIdentifier("historyTableCell") as HistoryTableCell
    cell.titleLabel.text = item.label
    cell.dateLabel.text = timeOfDayFormatter.stringFromDate(item.date)
    return cell
  }

  func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }

  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
      let item = items[indexPath.item]
      items.removeAtIndex(indexPath.item)

      if item.type == "breast" {
        BreastSvc.remove(item.id) { err in }
      } else if item.type == "bottle" {
        BottleSvc.remove(item.id) { err in }
      }

      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
  }

  // Protocol: UITableViewDelegate
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {}

}
