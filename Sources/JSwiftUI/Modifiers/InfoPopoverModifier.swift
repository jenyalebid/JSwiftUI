//
//  InfoPopoverModifier.swift
//  JSwiftUI
//

import SwiftUI

public struct InfoPopoverSettings {
    public var maxWidth: CGFloat = 260
    public var disableZoomTransition: Bool = false
    public var arrowEdge: Edge = .top

    public init(maxWidth: CGFloat = 260, disableZoomTransition: Bool = false, arrowEdge: Edge = .top) {
        self.maxWidth = maxWidth
        self.disableZoomTransition = disableZoomTransition
        self.arrowEdge = arrowEdge
    }
}

public extension EnvironmentValues {
    @Entry var infoPopoverSettings = InfoPopoverSettings()
}

public extension View {
    func infoPopoverMaxWidth(_ width: CGFloat) -> some View {
        transformEnvironment(\.infoPopoverSettings) { settings in
            settings.maxWidth = width
        }
    }
    func infoPopoverDisableZoom(_ disable: Bool = true) -> some View {
        transformEnvironment(\.infoPopoverSettings) { settings in
            settings.disableZoomTransition = disable
        }
    }
    func infoPopoverArrowEdge(_ edge: Edge) -> some View {
        transformEnvironment(\.infoPopoverSettings) { settings in
            settings.arrowEdge = edge
        }
    }
}

public struct InfoPopoverModifier<PopoverContent: View>: ViewModifier {

    @Binding var isPresented: Bool
    var icon: String?
    var onDismiss: (() -> Void)?
    @ViewBuilder var popoverContent: () -> PopoverContent

    @Environment(\.infoPopoverSettings) private var settings
    @Namespace private var namespace

    public init(isPresented: Binding<Bool>, icon: String? = nil, onDismiss: (() -> Void)? = nil, @ViewBuilder popoverContent: @escaping () -> PopoverContent) {
        self._isPresented = isPresented
        self.icon = icon
        self.onDismiss = onDismiss
        self.popoverContent = popoverContent
    }

    public func body(content: Content) -> some View {
        Group {
            if settings.disableZoomTransition {
                content
                    .onTapGesture { isPresented.toggle() }
                    .popover(isPresented: $isPresented, arrowEdge: settings.arrowEdge) {
                        popoverInner()
                    }
            } else {
                if #available(iOS 18.0, *) {
                    content
                        .matchedTransitionSource(id: "infoPopover", in: namespace)
                        .onTapGesture { isPresented.toggle() }
                        .popover(isPresented: $isPresented, arrowEdge: settings.arrowEdge) {
                            popoverInner()
                                .navigationTransition(.zoom(sourceID: "infoPopover", in: namespace))
                        }
                } else {
                    content
                        .onTapGesture { isPresented.toggle() }
                        .popover(isPresented: $isPresented, arrowEdge: settings.arrowEdge) {
                            popoverInner()
                        }
                }
            }
        }
        .onChange(of: isPresented) { _, showing in
            if !showing {
                onDismiss?()
            }
        }
    }

    @ViewBuilder
    private func popoverInner() -> some View {
        HStack(spacing: 10) {
            if let icon {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
            popoverContent()
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
            Button {
                isPresented = false
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.subheadline)
                    .foregroundStyle(.quaternary)
            }
            .buttonStyle(.plain)
        }
        .frame(idealWidth: settings.maxWidth, maxWidth: settings.maxWidth)
        .padding()
        .contentShape(Rectangle())
        .onTapGesture { isPresented = false }
        .presentationCompactAdaptation(.popover)
    }
}

public extension View {
    func infoPopover<Content: View>(
        isPresented: Binding<Bool>,
        icon: String? = nil,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(InfoPopoverModifier(isPresented: isPresented, icon: icon, onDismiss: onDismiss, popoverContent: content))
    }
}
