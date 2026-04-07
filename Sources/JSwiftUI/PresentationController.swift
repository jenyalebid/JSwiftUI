//
//  PresentationController.swift
//  JSwiftUI
//
//  Created by Jenya Lebid on 4/23/25.
//

import SwiftUI

public protocol PresentationViewHost: View, Identifiable, Equatable {
    var sheetDetents: Set<PresentationDetent> { get }
    var sheetBackground: AnyShapeStyle? { get }
}

extension PresentationViewHost {
    public var sheetDetents: Set<PresentationDetent> { [.large] }
    public var sheetBackground: AnyShapeStyle? { nil }
}

@Observable
public final class PresentationController<ViewHost: PresentationViewHost>: Sendable {

    internal var activeSheet: ViewHost?
    internal var activeFullScreenCover: ViewHost?
    internal var activePopover: ViewHost?

    public internal(set) var namespace: Namespace.ID

    public var isPresenting: Bool {
        activeSheet != nil || activeFullScreenCover != nil || activePopover != nil
    }

    internal init(namespace: Namespace.ID) {
        self.namespace = namespace
    }

    /// Calls presentation of a specified sheet view.
    /// - Important: `presentationController()` modifier must be attached at root view of intended
    /// presentation source to function correctly.
    public func sheet(for viewHost: ViewHost) {
        self.activeSheet = viewHost
    }

    public func fullScreenCover(for viewHost: ViewHost) {
        self.activeFullScreenCover = viewHost
    }

    public func popover(for viewHost: ViewHost) {
        self.activePopover = viewHost
    }

    /// Dismiss any actively presented sheet.
    public func dismiss() {
        activeSheet = nil
        activeFullScreenCover = nil
    }
}

fileprivate struct PresentationControllerModifier<ViewHost: PresentationViewHost>: ViewModifier {

    @State private var controller: PresentationController<ViewHost>

    init( namespace: Namespace.ID) {
        _controller = State(wrappedValue: PresentationController<ViewHost>(namespace: namespace))
    }

    func body(content: Content) -> some View {
        content
            .environment(controller)
            .popover(item: $controller.activePopover, content: { popover in
                popover
                    .presentationController(for: ViewHost.self, namespace: controller.namespace)
                    .environment(\.isPresentedOverRoot, true)
            })
            .sheet(item: $controller.activeSheet) { sheet in
                sheet
                    .presentationController(for: ViewHost.self, namespace: controller.namespace)
                    .presentationDetents(sheet.sheetDetents)
                    .modifier(SheetBackgroundModifier(background: sheet.sheetBackground))
                    .environment(\.isPresentedOverRoot, true)
            }
            .fullScreenCover(item: $controller.activeFullScreenCover) { sheet in
                sheet
                    .presentationController(for: ViewHost.self, namespace: controller.namespace)
                    .environment(\.isPresentedOverRoot, true)
            }
    }
}

/// Applies optional sheet background without conditional ViewBuilder issues.
fileprivate struct SheetBackgroundModifier: ViewModifier {
    let background: AnyShapeStyle?

    func body(content: Content) -> some View {
        if let background {
            content.presentationBackground(background)
        } else {
            content
        }
    }
}

fileprivate struct PresentationNamespaceModifier<ViewHost: PresentationViewHost>: ViewModifier {

    @Namespace private var namespace

    func body(content: Content) -> some View {
        content
            .presentationController(for: ViewHost.self, namespace: namespace)

    }
}

public extension View {
    func presentationController<ViewHost: PresentationViewHost>(for ViewHost: ViewHost.Type, namespace: Namespace.ID) -> some View {
        modifier(PresentationControllerModifier<ViewHost>(namespace: namespace))
    }

    @ViewBuilder
    func presentationController<ViewHost: PresentationViewHost>(for ViewHost: ViewHost.Type) -> some View {
        self.modifier(PresentationNamespaceModifier<ViewHost>())
    }
}
