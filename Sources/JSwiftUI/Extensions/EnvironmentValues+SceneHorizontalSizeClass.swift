//
//  EnvironmentValues+SceneHorizontalSizeClass.swift
//  JSwiftUI
//

import SwiftUI

public extension EnvironmentValues {
    /// The horizontal size class of the underlying scene, propagated past sheet
    /// and popover presentations. Use this in modal content when you need to
    /// make layout decisions based on the device context rather than the sheet's
    /// own (often `.compact`) size class.
    @Entry var sceneHorizontalSizeClass: UserInterfaceSizeClass? = nil
}

public extension View {
    /// Captures the current `horizontalSizeClass` and publishes it as
    /// `sceneHorizontalSizeClass` to all descendants, including modal
    /// presentations (sheets, popovers, fullScreenCovers) that would otherwise
    /// report a different size class.
    ///
    /// Apply on a root-level view (e.g. a screen or scene entry point).
    func captureSceneHorizontalSizeClass() -> some View {
        modifier(CaptureSceneHorizontalSizeClassModifier())
    }
}

private struct CaptureSceneHorizontalSizeClassModifier: ViewModifier {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    func body(content: Content) -> some View {
        content.environment(\.sceneHorizontalSizeClass, horizontalSizeClass)
    }
}
