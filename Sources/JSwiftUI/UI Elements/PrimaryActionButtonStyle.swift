//
//  PrimaryActionButtonStyle.swift
//  JSwiftUI
//
//  Created by Jenya Lebid on 8/15/25.
//

import SwiftUI

struct PrimaryActionButtonStyleSettings {
    
    var labelFont: Font = .title2
}

extension EnvironmentValues {
    @Entry var primaryActionButtonStyleSettings = PrimaryActionButtonStyleSettings()
}

public extension View {
    func primaryActionButtonFont(_ font: Font) -> some View {
        transformEnvironment(\.primaryActionButtonStyleSettings) { settings in
            settings.labelFont = font
        }
    }
}

public struct PrimaryActionButtonStyle: ButtonStyle {
    
    @Environment(\.primaryActionButtonStyleSettings) private var settings
    
    private var style: Style
    private var feedback: SensoryFeedback?
    
    public init(_ style: Style = .accent, feedback: SensoryFeedback? = .selection) {
        self.style = style
        self.feedback = feedback
    }
    
    public enum Style {
        case accent
        case destructive
        case dark // To go around iOS 18 ButtonStyle issue for custom manual set ColorScheme.
    }
    
    @Environment(\.isEnabled) private var enabled
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var feedbackToggle = false
    
    private var foregroundColor: Color {
        switch style {
        case .accent:
            colorSchemeForeground
        case .destructive:
                .white
        case .dark:
                .black
        }
        
    }
    
    private var background: Color {
        switch style {
        case .accent:
            colorSchemeBackground
        case .destructive:
                .red
        case .dark:
                .white
        }
    }
    
    private var colorSchemeBackground: Color {
        switch colorScheme {
        case .dark:
                .white
        case .light:
                .black
        @unknown default:
                .black
        }
    }
    
    var colorSchemeForeground: Color {
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
            .font(settings.labelFont)
            .fontWeight(.bold)
            .foregroundStyle(foregroundColor)
            .padding()
            .frame(maxWidth: .infinity)
            .background(background)
            .clipShape(Capsule())
            .shadow(radius: 5)
            .opacity(opacity(for: configuration))
            .padding()
            .sensoryFeedback(feedback ?? .impact, trigger: feedbackToggle)
            .onChange(of: configuration.isPressed) { _, isPressed in
                guard isPressed, feedback != nil else { return }
                feedbackToggle.toggle()
            }
    }
    
    private func opacity(for config: Configuration) -> Double {
        guard enabled else {
            return 0.5
        }
        return config.isPressed ? 0.6 : 1
    }
}
