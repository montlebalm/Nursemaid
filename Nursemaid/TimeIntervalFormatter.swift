//
//  TimeIntervalFormatter.swift
//  Nursemaid
//
//  Created by Chris Montrois on 2/26/15.
//  Copyright (c) 2015 bigevilrobot. All rights reserved.
//

import Foundation

class TimeIntervalFormatter {

  class func format(elapsed: NSTimeInterval) -> String {
    let minutes = Int(elapsed / 60)
    let seconds = Int(elapsed % 60)
    let secondsFormatted = seconds < 10 ? "0\(seconds)" : "\(seconds)"
    return "\(minutes):\(secondsFormatted)"
  }

}