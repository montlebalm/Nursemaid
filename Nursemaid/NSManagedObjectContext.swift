//
//  NSManagedObjectContext.swift
//  Nursemaid
//
//  Created by Chris Montrois on 3/1/15.
//  Copyright (c) 2015 bigevilrobot. All rights reserved.
//

import CoreData
import Foundation

extension NSManagedObjectContext {

  func save() -> NSError? {
    var error : NSError?
    self.save(&error)
    return error
  }

}
