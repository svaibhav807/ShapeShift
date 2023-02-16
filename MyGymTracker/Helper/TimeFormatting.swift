//
//  TimeFormatting.swift
//  MyGymTracker
//
//  Created by Vaibhav Singh on 09/01/23.
//

import Foundation

func timeSince(date: Date) -> String {
    let minutes = Int(-date.timeIntervalSinceNow)/60
       let hours = minutes/60
       let days = hours/24

       if minutes < 120 {
           return "\(minutes) minutes ago"
       } else if minutes >= 120 && hours < 24 {
           return "\(hours) hours ago"
       } else {
           return "\(days) days ago"
       }
}
