//
//  Event.swift
//  EITS
//
//  Created by Lakshay Sharma on 12/10/16.
//  Copyright © 2016 Lakshay Sharma. All rights reserved.
//

import Foundation

class Event {
    var eventName: String
    var eventStartDate: String
    var eventEndDate: String
    
    /*
     *
     *
     Initializer for Event objects.
     *
     *
     */
    init?(name: String, start: String, end: String) {
        eventName = name
        eventStartDate = start
        eventEndDate = end
        
        /*
         *
         *
         If input is empty, then nil is returned so program does no crash
         *
         *
         */
        if (name.isEmpty && start.isEmpty && end.isEmpty) {
            return nil
        }
    }
}
