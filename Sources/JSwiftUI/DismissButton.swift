//
//  DismissButton.swift
//  JSwiftUI
//
//  Created by Jenya Lebid on 4/20/24.
//

import SwiftUI

public struct DismissButton: View {
    
    @Environment(\.dismiss) var dismiss
    
    var environmentDismiss: Bool
    var onDismiss: () -> Void
    
    public init(environmentDismiss: Bool = true, onDismiss: @escaping () -> Void = {}) {
        self.environmentDismiss = environmentDismiss
        self.onDismiss = onDismiss
    }

    public var body: some View {
        Button {
            onDismiss()
            if environmentDismiss {
                dismiss()
            }
        } label: {
            Image(systemName: "xmark")
                .foregroundStyle(.gray)
                .fontWeight(.bold)
        }
        .buttonStyle(.bordered)
        .buttonBorderShape(.circle)
    }
}
