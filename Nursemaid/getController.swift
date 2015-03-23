import UIKit

func getController(storyboard: String, controllerId: String) -> UIViewController {
  let board = UIStoryboard(name: storyboard, bundle: nil)
  return board.instantiateViewControllerWithIdentifier(controllerId) as UIViewController
}
