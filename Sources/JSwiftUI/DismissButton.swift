//
//  DismissButton.swift
//  JSwiftUI
//
//  Created by Jenya Lebid on 4/20/24.
//

import SwiftUI

public struct DismissButton<L: View>: View {
    
    public enum Style {
        case custom
        case xmark
        case done
        case save
        case cancel
        case checkmark
    }
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
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
        switch style {
        case .checkmark:
            if #available(iOS 26.0, *) {
//                if style == .checkmark {
                    Button(role: .close, action: buttonAction) {
                        checkmark
                    }
//                }
//                else { // Issues with prominent with sheets.
//                    Button(role: .confirm, action: buttonAction) {
//                        checkmark
//                    }
//                    .buttonStyle(.borderedProminent)
//                    .buttonBorderShape(.circle)
//                }
            }
            else {
                DismissButtonUI(style: .done, environmentDismiss: environmentDismiss, onDismiss: onDismiss)
            }
        default:
            Button(action: buttonAction) {
                switch style {
                case .custom:
                    label
                case .xmark:
                    xmark
                case .checkmark:
                    checkmark
                case .done:
                    Self.doneLabel
                case .save:
                    Self.saveLabel
                case .cancel:
                    Self.cancelLabel
                }
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
    
    private var checkmark: some View {
        Image(systemName: "checkmark")
            .font(.headline)
            .fontWeight(.bold)
    }
    
    private func buttonAction() {
        onDismiss?()
        if environmentDismiss {
            dismiss()
        }
    }

}

public typealias DismissButtonUI = DismissButton<EmptyView>

public extension DismissButton {
    
    static var xmarkLabel: some View {
        Image(systemName: "xmark")
            .foregroundStyle(Color(uiColor: .label))
            .fontWeight(.bold)
    }
    
    static var saveLabel: some View {
        Text("Save")
            .font(.headline)
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
