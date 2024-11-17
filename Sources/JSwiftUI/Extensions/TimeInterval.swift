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
        let secondsText = abbreviated ? "s" : "seconds"
        
        let time = Int(self)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600) % 24
        let days = time / 86400
        
        if days > 1 {
            return "\(days) days"
        } else if days == 1 {
            return "1 day"
        } else if hours > 1 {
            return "\(hours) \(forceSingle ? hourText : hoursText)"
        } else if hours == 1 {
            return "1 \(hourText)"
        } else if minutes > 1 {
            return "\(minutes) \(forceSingle ? minText : minutesText)"
        } else if minutes == 1 {
            return "1 \(minText)"
        } else {
            return "\(seconds) \(secondsText)"
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
    
//    func convertSeconds(to component: Calendar.Component) -> Double? {
//        let secondsInUnit: Double?
//        
//        switch component {
//        case .second:
//            secondsInUnit = 1
//        case .minute:
//            secondsInUnit = 60
//        case .hour:
//            secondsInUnit = 3600
//        case .day:
//            secondsInUnit = 86400
//        case .weekOfYear, .weekOfMonth:
//            secondsInUnit = 604800
//        case .month:
//            // Approximation: 30.44 days per month
//            secondsInUnit = 86400 * 30.44
//        case .year:
//            // Approximation: 365.25 days per year
//            secondsInUnit = 86400 * 365.25
//        default:
//            // Return nil if the component is not supported
//            secondsInUnit = nil
//        }
//        
//        // If a valid component was provided, return the converted value
//        if let secondsInUnit = secondsInUnit {
//            return self / secondsInUnit
//        } else {
//            // Unsupported component
//            return nil
//        }
//    }
    
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
