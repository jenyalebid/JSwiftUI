//
//  DismissButton.swift
//  JSwiftUI
//
//  Created by Jenya Lebid on 4/20/24.
//

import SwiftUI

public struct DismissButton: View {
    
    public enum Style {
        case xmark
        case done
        case cancel
    }
    
    @Environment(\.dismiss) private var dismiss
    
    private var environmentDismiss: Bool
    private var onDismiss: (() -> Void)?
    
    private var style: Style
    
    public init(style: Style = .xmark, environmentDismiss: Bool = true, onDismiss: (() -> Void)? = nil) {
        self.style = style
        self.environmentDismiss = environmentDismiss
        self.onDismiss = onDismiss
    }

    public var body: some View {
        Button {
            onDismiss?()
            if environmentDismiss {
                dismiss()
            }
        } label: {
            switch style {
            case .xmark:
                xmark
            case .done:
                done
            case .cancel:
                cancel
            }
        }
    }
    
    var xmark: some View {
        Image(systemName: "xmark")
            .foregroundStyle(.gray)
            .fontWeight(.bold)
            .padding(7)
            .background(Color(uiColor: .systemGray5))
            .clipShape(Circle())
            .imageScale(.medium)
    }
    
    var done: some View {
        Text("Done")
            .font(.headline)
    }
    
    var cancel: some View {
        Text("Cancel")
    }
}

public extension DismissButton {
    
    func toolbarItem(placement: ToolbarItemPlacement = .automatic) -> some ToolbarContent {
        ToolbarItem(placement: placement) {
            self
        }
    }
}

#Preview {
    DismissButton()
}
