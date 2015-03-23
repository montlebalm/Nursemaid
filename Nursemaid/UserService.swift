import Foundation
import Parse

class UserService {

  func login(username: String, password: String, callback: (NSError?) -> ()) {
    PFUser.logInWithUsernameInBackground(username, password: password) { user, err in
      if err != nil {
        return callback(err)
      }

      if user == nil {
        return callback(NSError())
      }

      callback(nil)
    }
  }

}
