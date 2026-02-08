//
//  SwiftUIView.swift
//  
//
//  Created by Jenya Lebid on 8/22/24.
//

import Foundation

public extension TimeInterval {
    
    func toReadableString(abbreviated: Bool = true, forceSingle: Bool = false) -> String {
        let hoursText = abbreviated ? "hrs" : "hours"
        let hourText = abbreviated ? "hr" : "hour"
        let minText = abbreviated ? "min" : "minute"
        let minutesText = abbreviated ? "min" : "minutes"
        
        // Round down to the nearest minute
        let totalMinutes = Int(self / 60)
        let minutes = totalMinutes % 60
        let hours = (totalMinutes / 60) % 24
        let days = totalMinutes / 1440 // 1440 minutes in a day
        
        if days > 1 {
            return "\(days) days"
        } else if days == 1 {
            return "1 day"
        } else if hours > 0 {
            let hourLabel = hours == 1 ? hourText : (forceSingle ? hourText : hoursText)
            // Only show minutes if there are any remaining minutes
            if minutes > 0 {
                let minuteLabel = minutes == 1 ? minText : (forceSingle ? minText : minutesText)
                return "\(hours) \(hourLabel), \(minutes) \(minuteLabel)"
            } else {
                return "\(hours) \(hourLabel)"
            }
        } else if minutes > 1 {
            return "\(minutes) \(forceSingle ? minText : minutesText)"
        } else if minutes == 1 {
            return "1 \(minText)"
        } else {
            // Less than a minute shows as 0 min
            return "0 \(minutesText)"
        }
    }
    
    func toHourReadableString() -> String {
        let totalMinutes = Int(self) / 60
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        
        if hours > 0 {
            return "\(hours) hr\(hours > 1 ? "s" : ""), \(minutes) min"
        } else {
            return "\(minutes) min"
        }
    }
    
    var hoursAndMinutes: (hours: Int, minutes: Int) {
        let totalMinutes = Int(self) / 60
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        return (hours, minutes)
    }

    func convert(from sourceComponent: Calendar.Component, to targetComponent: Calendar.Component) -> Double? {
        let secondsInSourceUnit: Double?
        let secondsInTargetUnit: Double?
        
        func seconds(for component: Calendar.Component) -> Double? {
            switch component {
            case .second:
                return 1
            case .minute:
                return 60
            case .hour:
                return 3600
            case .day:
                return 86400
            case .weekOfYear, .weekOfMonth:
                return 604800
            case .month:
                // Approximation: 30.44 days per month
                return 86400 * 30.44
            case .year:
                // Approximation: 365.25 days per year
                return 86400 * 365.25
            default:
                // Unsupported component
                return nil
            }
        }
        
        secondsInSourceUnit = seconds(for: sourceComponent)
        secondsInTargetUnit = seconds(for: targetComponent)
        
        // If valid components were provided, return the converted value
        if let source = secondsInSourceUnit, let target = secondsInTargetUnit {
            return (self * source) / target
        } else {
            // Unsupported component
            return nil
        }
    }
}
