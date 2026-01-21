//
//  SwiftUIView.swift
//  JSwiftUI
//
//  Created by Jenya Lebid on 1/16/25.
//

import SwiftUI

public extension View {
    
    /// Sets the foreground style of view to white or black determined on current background
    /// for best clarity.
    @ViewBuilder
    func readableForeground(for color: Color?, isEnabled: Bool = true) -> some View {
        if isEnabled, let color {
            self.readableForeground(for: color)
        }
        else {
            self
        }
    }
    
    func readableForeground(for color: Color) -> some View {
        var r, g, b, a: CGFloat
        (r, g, b, a) = (0, 0, 0, 0)
        UIColor(color).getRed(&r, green: &g, blue: &b, alpha: &a)
        let luminance = 0.2126 * r + 0.7152 * g + 0.0722 * b
        return  luminance < 0.6 ? self.foregroundStyle(.white) : self.foregroundStyle(.black)
    }
}
