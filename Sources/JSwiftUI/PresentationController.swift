//
//  PresentationController.swift
//  JSwiftUI
//
//  Created by Jenya Lebid on 4/23/25.
//

import SwiftUI

public protocol PresentationViewHost: View, Identifiable, Equatable {}

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
//    @Namespace private var namespace

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
                    .environment(\.isPresentedOverRoot, true)
            }
            .fullScreenCover(item: $controller.activeFullScreenCover) { sheet in
                sheet
                    .presentationController(for: ViewHost.self, namespace: controller.namespace)
                    .environment(\.isPresentedOverRoot, true)
            }
    }
}

public extension View {
    func presentationController<ViewHost: PresentationViewHost>(for ViewHost: ViewHost.Type, namespace: Namespace.ID) -> some View {
        modifier(PresentationControllerModifier<ViewHost>(namespace: namespace))
    }
}

