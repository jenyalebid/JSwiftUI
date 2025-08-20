//
//  PrimaryActionButtonStyle.swift
//  JSwiftUI
//
//  Created by Jenya Lebid on 8/15/25.
//

import SwiftUI

public struct PrimaryActionButtonStyle: ButtonStyle {
    
    var style: Style
    
    public init(_ style: Style = .accent) {
        self.style = style
    }
    
    public enum Style {
        case accent
        case destructive
        case dark // To go around iOS 18 ButtonStyle issue for custom manual set ColorScheme.
    }
    
    @Environment(\.isEnabled) private var enabled
    @Environment(\.colorScheme) private var colorScheme
    
    private var foregroundColor: Color {
        switch style {
        case .accent:
            colorSchmeForeground
        case .destructive:
                .white
        case .dark:
                .black
        }
        
    }
    
    private var background: Color {
        switch style {
        case .accent:
            colorShemeBackground
        case .destructive:
                .red
        case .dark:
                .white
        }
    }
    
    private var colorShemeBackground: Color {
        switch colorScheme {
        case .dark:
                .white
        case .light:
                .black
        @unknown default:
                .black
        }
    }
    
    var colorSchmeForeground: Color {
        switch colorScheme {
        case .dark:
            return .black
        case .light:
            return .white
        @unknown default:
            return .white
        }
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title2)
            .fontWeight(.bold)
            .foregroundStyle(foregroundColor)
            .padding()
            .frame(maxWidth: .infinity)
            .background(background)
            .clipShape(Capsule())
            .shadow(radius: 5)
            .opacity(opacity(for: configuration))
            .padding()
    }
    
    private func opacity(for config: Configuration) -> Double {
        guard enabled else {
            return 0.5
        }
        return config.isPressed ? 0.6 : 1
    }
}
