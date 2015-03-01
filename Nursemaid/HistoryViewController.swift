import CoreData
import UIKit

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  var breastFeedings = [BreastFeeding]()
  let context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
  let timeOfDayFormatter = NSDateFormatter()

  @IBOutlet weak var tableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()

    timeOfDayFormatter.dateStyle = .ShortStyle
    timeOfDayFormatter.timeStyle = .ShortStyle

    BreastFeeding.createInContext(context!, leftSeconds: 950, rightSeconds: 700, lastSide: "r", startTime: NSDate(), endTime: NSDate())
    BreastFeeding.createInContext(context!, leftSeconds: 800, rightSeconds: 650, lastSide: "l", startTime: NSDate(), endTime: NSDate())

    fetchData()
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  func fetchData() {
    breastFeedings = retrieveBreastFeedings()
  }

  func retrieveBreastFeedings() -> [BreastFeeding] {
    let fetch = NSFetchRequest(entityName: "BreastFeeding")
    return context!.executeFetchRequest(fetch, error: nil) as? [BreastFeeding] ?? []
  }

  // Protocol: UITableViewDataSource

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return breastFeedings.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let item = breastFeedings[indexPath.item] as BreastFeeding
    let leftTime = TimeIntervalFormatter.format(Double(item.leftSideSeconds))
    let rightTime = TimeIntervalFormatter.format(Double(item.rightSideSeconds))

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
      context?.deleteObject(item)
      breastFeedings.removeAtIndex(indexPath.item)

      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
  }

  // Protocol: UITableViewDelegate
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
  }

}
