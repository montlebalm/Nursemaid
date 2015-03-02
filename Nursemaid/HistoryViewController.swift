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
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

    fetchData()
    tableView.reloadData()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  func fetchData() {
    breastFeedings = retrieveBreastFeedings()
  }

  func retrieveBreastFeedings() -> [BreastFeeding] {
    let fetch = NSFetchRequest(entityName: "BreastFeeding")

    let sortDescriptor = NSSortDescriptor(key: "endTime", ascending: false)
    fetch.sortDescriptors = [sortDescriptor]

    return context!.executeFetchRequest(fetch, error: nil) as? [BreastFeeding] ?? []
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

      // Remove the item from Core Data
      context?.deleteObject(item)
      context?.save()

      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
  }

  // Protocol: UITableViewDelegate
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {}

}
