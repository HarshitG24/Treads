//
//  Extensions.swift
//  Treads
//
//  Created by Harshit Gajjar on 6/23/20.
//  Copyright © 2020 ThinkX. All rights reserved.
//

import Foundation

extension Double{
    func meterToMiles(places: Int) -> Double{
        let divisor = pow(10.0, Double(places))
        return ((self / 1609.34) * divisor).rounded() / divisor
    }
}

extension Int{
    func formatTimeDurationToString() -> String{
        let durationHours = self / 3600
        let minDuration = (self % 3600) / 60
        let secDuration = (self % 3600) % 60
        
        if secDuration < 0{
            return "00:00:00"
        }else{
            if durationHours == 0{
                return String(format: "%02d:%02d", minDuration, secDuration)
            }else{
                return String(format: "%02d:%02d:%02d", durationHours, minDuration, secDuration)
            }
        }
    }
}

extension NSDate{
    func getDateString() -> String{
        let calender =  Calendar.current
        let month = calender.component(.month, from: self as Date)
        let day = calender.component(.day, from: self as Date)
        let year = calender.component(.year, from: self as Date)
        
        return "\(day)/\(month)/\(year)"
    }
}
