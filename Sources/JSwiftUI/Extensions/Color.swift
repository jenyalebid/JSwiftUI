//
//  Color.swift
//  JSwiftUI
//
//  Created by Jenya Lebid on 6/30/23.
//

import SwiftUI

public extension Color {
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    init(r: Double, g: Double, b: Double, a: Double = 1.0) {
        self.init(
            red: r / 255.0,
            green: g / 255.0,
            blue: b / 255.0,
            opacity: a
        )
    }
}

public extension Color {
    
    func lighter(by percentage: CGFloat = 0.2) -> Color {
        return self.adjust(by: abs(percentage))
    }

    func darker(by percentage: CGFloat = 0.2) -> Color {
        return self.adjust(by: -abs(percentage))
    }

    func adjust(by percentage: CGFloat = 0.2) -> Color {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        UIColor(self).getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return Color(
            .sRGB,
            red: min(red + percentage, 1.0),
            green: min(green + percentage, 1.0),
            blue: min(blue + percentage, 1.0),
            opacity: alpha
        )
    }
}

public extension Color {
    
    var hex: String? {
        guard let cgColor = self.cgColor else { return nil }
        guard let components = cgColor.components else { return nil }
        
        var r, g, b: CGFloat
        let numberOfComponents = cgColor.numberOfComponents
        
        if numberOfComponents == 2 { // Grayscale and alpha
            r = components[0]
            g = components[0]
            b = components[0]
        } else if numberOfComponents == 4 { // RGB and alpha
            r = components[0]
            g = components[1]
            b = components[2]
        } else {
            return nil // Unsupported color space
        }
        
        return String(format: "%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }
}

public extension Color {
    
    static func secondaryLabel(for colorScheme: ColorScheme, opacity: CGFloat = 0.6) -> Self {
        switch colorScheme {
        case .dark:
            Color(.sRGB, red: 235/255, green: 235/255, blue: 245/255, opacity: opacity)
        case .light:
            Color(.sRGB, red: 60/255, green: 60/255, blue: 67/255, opacity: opacity)
        @unknown default:
            Color(.sRGB, red: 235/255, green: 235/255, blue: 245/255, opacity: opacity)
        }
    }
}
