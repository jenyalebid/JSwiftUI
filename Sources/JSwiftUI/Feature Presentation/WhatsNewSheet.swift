//
//  WhatsNewSheet.swift
//  JSwiftUI
//
//  Created by Jenya Lebid on 4/13/26.
//

import SwiftUI

/// A single feature item for the What's New sheet.
public struct WhatsNewFeature: Identifiable {
    public let id = UUID()
    public var systemImage: String
    public var tint: Color
    public var title: String
    public var description: String

    public init(systemImage: String, tint: Color = .accentColor, title: String, description: String) {
        self.systemImage = systemImage
        self.tint = tint
        self.title = title
        self.description = description
    }
}

/// Apple-style "What's New" sheet shown on version updates.
///
/// Usage:
/// ```swift
/// .whatsNewSheet(
///     currentVersion: Bundle.main.appVersion,
///     features: [
///         WhatsNewFeature(systemImage: "star.fill", tint: .yellow, title: "Daily Games", description: "Play a new challenge every day."),
///         WhatsNewFeature(systemImage: "chart.bar.fill", tint: .blue, title: "Statistics", description: "Track your performance over time."),
///     ]
/// )
/// ```
public struct WhatsNewSheet<Title: View>: View {

    @Environment(\.dismiss) private var dismiss

    private var title: Title
    private var features: [WhatsNewFeature]

    public init(features: [WhatsNewFeature], @ViewBuilder title: () -> Title) {
        self.title = title()
        self.features = features
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    header
                    featureList
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .padding(.bottom, 24)
            }
            .safeAreaInset(edge: .bottom) {
                continueButton
            }
            .toolbar {
                DismissButton().toolbarItem(placement: .topBarTrailing)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var header: some View {
        VStack(spacing: 8) {
            Text("What's New in")
                .font(.largeTitle)
                .fontWeight(.bold)
            title
        }
        .multilineTextAlignment(.center)
    }

    private var featureList: some View {
        VStack(alignment: .leading, spacing: 24) {
            ForEach(features) { feature in
                featureRow(feature)
            }
        }
    }

    private func featureRow(_ feature: WhatsNewFeature) -> some View {
        HStack(spacing: 16) {
            Image(systemName: feature.systemImage)
                .font(.title)
                .foregroundStyle(feature.tint)
                .frame(width: 50, height: 50)
            VStack(alignment: .leading, spacing: 2) {
                Text(feature.title)
                    .font(.body)
                    .fontWeight(.semibold)
                Text(feature.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var continueButton: some View {
        Button {
            dismiss()
        } label: {
            Text("Continue")
        }
        .buttonStyle(PrimaryActionButtonStyle())
        .padding(.horizontal, 24)
        .padding(.bottom, 8)
    }
}

public extension WhatsNewSheet where Title == Text {

    init(appName: String, features: [WhatsNewFeature]) {
        self.features = features
        self.title = Text(appName)
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundStyle(Color.accentColor)
    }
}

// MARK: - Version Tracking

public enum WhatsNewVersion {

    /// The UserDefaults key used to track the last seen version for this bundle.
    public static var lastSeenKey: String {
        let bundleID = Bundle.main.bundleIdentifier ?? "unknown"
        return "whatsNew_lastSeenVersion_\(bundleID)"
    }

    /// Seed a previous version so the next launch detects a version change.
    /// Call this once during migration for existing users who predate What's New tracking.
    public static func seedPreviousVersion(_ version: String) {
        guard UserDefaults.standard.string(forKey: lastSeenKey) == nil else { return }
        UserDefaults.standard.set(version, forKey: lastSeenKey)
    }
}

// MARK: - View Modifier

struct WhatsNewModifier<Title: View>: ViewModifier {

    var currentVersion: String
    var features: [WhatsNewFeature]
    var title: Title

    @State private var showSheet = false

    func body(content: Content) -> some View {
        content
            .onAppear {
                guard !features.isEmpty else { return }
                let lastSeen = UserDefaults.standard.string(forKey: WhatsNewVersion.lastSeenKey)
                if let lastSeen {
                    if lastSeen != currentVersion {
                        showSheet = true
                    }
                } else {
                    UserDefaults.standard.set(currentVersion, forKey: WhatsNewVersion.lastSeenKey)
                }
            }
            .sheet(isPresented: $showSheet) {
                UserDefaults.standard.set(currentVersion, forKey: WhatsNewVersion.lastSeenKey)
            } content: {
                WhatsNewSheet(features: features) { title }
            }
    }
}

public extension View {

    /// Present a "What's New" sheet with a custom title view when the app version changes.
    func whatsNewSheet(
        currentVersion: String,
        features: [WhatsNewFeature],
        @ViewBuilder title: () -> some View
    ) -> some View {
        modifier(WhatsNewModifier(
            currentVersion: currentVersion,
            features: features,
            title: title()
        ))
    }

    /// Present a "What's New" sheet with a text app name when the app version changes.
    func whatsNewSheet(
        currentVersion: String,
        appName: String = Bundle.main.displayName,
        features: [WhatsNewFeature]
    ) -> some View {
        modifier(WhatsNewModifier(
            currentVersion: currentVersion,
            features: features,
            title: Text(appName)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(Color.accentColor)
        ))
    }
}

// MARK: - Bundle Helper

public extension Bundle {
    var appVersion: String {
        infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }

    var displayName: String {
        (infoDictionary?["CFBundleDisplayName"] ?? infoDictionary?["CFBundleName"]) as? String ?? "App"
    }
}

#Preview {
    WhatsNewSheet(appName: "Wordy", features: [
        WhatsNewFeature(systemImage: "gamecontroller.fill", tint: .purple, title: "Daily Games", description: "A new word challenge every day — come back for more."),
        WhatsNewFeature(systemImage: "chart.bar.fill", tint: .blue, title: "Statistics", description: "Track your wins, streaks, and performance over time."),
        WhatsNewFeature(systemImage: "person.2.fill", tint: .green, title: "Game Center", description: "Compete with friends on leaderboards and earn achievements."),
    ])
}
