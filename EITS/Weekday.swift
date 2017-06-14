//
//  Weekday.swift
//  EITS
//
//  Created by Lakshay Sharma on 12/10/16.
//  Copyright © 2016 Lakshay Sharma. All rights reserved.
//

import Foundation

class Weekday {
    /*
     *
     *
     Data for WeekDays
     *
     *
     */
    static let week = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    /*
     *
     *
     Returns the day based on an integer value between 0-6 inclusive 
     *
     *
     */
    static func getDay(number: Int) -> String {
        return week[number]
    }
}
