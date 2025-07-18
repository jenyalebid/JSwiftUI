//
//  PresentationController.swift
//  JSwiftUI
//
//  Created by Jenya Lebid on 4/23/25.
//

import SwiftUI

public protocol PresentationViewHost: View, Identifiable, Equatable {}

@Observable
public class PresentationController<ViewHost: PresentationViewHost> {
    
    public internal(set) var activeSheet: ViewHost?
    
    /// Calls presentation of a specified sheet view.
    /// - Important: `presentationController()` modifier must be attached at root view of intended
    /// presentation source to function correctly.
    public func sheet(for viewHost: ViewHost) {
        self.activeSheet = viewHost
    }
}

fileprivate struct PresentationControllerModifier<ViewHost: PresentationViewHost>: ViewModifier {
    
    @State private var controller = PresentationController<ViewHost>()
    
    func body(content: Content) -> some View {
        content
            .environment(controller)
            .sheet(item: $controller.activeSheet) { sheet in
                sheet
                    .presentationController(for: ViewHost.self)
            }
    }
}

public extension View {
    func presentationController<ViewHost: PresentationViewHost>(for ViewHost: ViewHost.Type) -> some View {
        modifier(PresentationControllerModifier<ViewHost>())
    }
}

