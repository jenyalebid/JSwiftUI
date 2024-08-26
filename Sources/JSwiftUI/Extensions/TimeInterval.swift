//
//  SwiftUIView.swift
//  
//
//  Created by Jenya Lebid on 8/22/24.
//

import Foundation

public extension TimeInterval {
    
    func toReadableString() -> String {
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
            return "\(hours) hrs"
        } else if hours == 1 {
            return "1 hr"
        } else if minutes > 1 {
            return "\(minutes) min"
        } else if minutes == 1 {
            return "1 min"
        } else {
            return "\(seconds) s"
        }
    }
}
