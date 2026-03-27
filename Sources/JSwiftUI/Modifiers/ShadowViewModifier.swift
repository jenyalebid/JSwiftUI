//
//  ShadowViewModifier.swift
//  JSwiftUI
//

import SwiftUI

public struct ShadowViewModifier: ViewModifier {

    @Environment(\.colorScheme) private var colorScheme

    var apply: Bool
    var radius: CGFloat

    public init(apply: Bool = true, radius: CGFloat = 10) {
        self.apply = apply
        self.radius = radius
    }

    public func body(content: Content) -> some View {
        content
            .shadow(color: Color(.sRGBLinear, white: 0, opacity: colorScheme == .light ? 0.33 : 0.8), radius: apply ? radius : 0)
    }
}

public extension View {
    func shadowModifier(apply: Bool = true, radius: CGFloat = 10) -> some View {
        modifier(ShadowViewModifier(apply: apply, radius: radius))
    }
}
