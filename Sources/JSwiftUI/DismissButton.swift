//
//  DismissButton.swift
//  JSwiftUI
//
//  Created by Jenya Lebid on 4/20/24.
//

import SwiftUI

public typealias DismissButtonUI = DismissButton<EmptyView>

public struct DismissButton<L: View>: View {
    
    public enum Style {
        case custom
        case xmark
        case done
        case cancel
    }
    
    @Environment(\.dismiss) private var dismiss
    
    @ViewBuilder
    private var label: L
    private var environmentDismiss: Bool
    private var onDismiss: (() -> Void)?
    
    private var style: Style
    
    public init(style: Style = .xmark,
                environmentDismiss: Bool = true, onDismiss: (() -> Void)? = nil) where L == EmptyView {
        self.style = style
        self.environmentDismiss = environmentDismiss
        self.onDismiss = onDismiss
        self.label = EmptyView()
    }
    
    public init(environmentDismiss: Bool = true, onDismiss: (() -> Void)? = nil, @ViewBuilder label: () -> L) {
        self.style = .custom
        self.environmentDismiss = environmentDismiss
        self.onDismiss = onDismiss
        self.label = label()
    }

    public var body: some View {
        Button {
            onDismiss?()
            if environmentDismiss {
                dismiss()
            }
        } label: {
            switch style {
            case .custom:
                label
            case .xmark:
                xmark
            case .done:
                Self.doneLabel
            case .cancel:
                Self.cancelLabel
            }
        }
    }
    
    @ViewBuilder
    private var xmark: some View {
        if #available(iOS 26, *) {
            Self.xmarkLabel
        }
        else {
            Self.xmarkLabel
                .padding(7)
                .background(Color(uiColor: .systemGray5))
                .clipShape(Circle())
                .imageScale(.medium)
        }
    }
    

}

public extension DismissButton {
    
    static var xmarkLabel: some View {
        Image(systemName: "xmark")
            .foregroundStyle(Color(uiColor: .label))
            .fontWeight(.bold)
    }
    
    static var doneLabel: some View {
        Text("Done")
            .font(.headline)
    }
    
    static var cancelLabel: some View {
        Text("Cancel")
    }
    
    func toolbarItem(placement: ToolbarItemPlacement = .automatic) -> some ToolbarContent {
        ToolbarItem(placement: placement) {
            self
        }
    }
}

#Preview {
    DismissButton()
}
