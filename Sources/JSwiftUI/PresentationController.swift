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
    
    internal var namespace: Namespace.ID?
    
    /// Calls presentation of a specified sheet view.
    /// - Important: `presentationController()` modifier must be attached at root view of intended
    /// presentation source to function correctly.
    public func sheet(for viewHost: ViewHost) {
        self.activeSheet = viewHost
    }
    
    public func fullScreenCover(for viewHost: ViewHost) {
        self.activeFullScreenCover = viewHost
    }
    
    /// Dismiss any actively presented sheet.
    public func dismiss() {
        activeSheet = nil
        activeFullScreenCover = nil
    }
}

fileprivate struct PresentationControllerModifier<ViewHost: PresentationViewHost>: ViewModifier {
    
    @State private var controller = PresentationController<ViewHost>()
    @Namespace private var namespace
    
    func body(content: Content) -> some View {
        content
            .environment(controller)
            .sheet(item: $controller.activeSheet) { sheet in
                sheet
                    .presentationController(for: ViewHost.self)
            }
            .fullScreenCover(item: $controller.activeFullScreenCover) { sheet in
                sheet
                    .presentationController(for: ViewHost.self)
            }
            .onAppear {
                controller.namespace = namespace
            }
    }
}

public extension View {
    func presentationController<ViewHost: PresentationViewHost>(for ViewHost: ViewHost.Type) -> some View {
        modifier(PresentationControllerModifier<ViewHost>())
    }
}

