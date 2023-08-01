//
//  BooleanBlock.swift
//  JSwiftUI
//
//  Created by Jenya Lebid on 8/1/23.
//

import SwiftUI

public struct BooleanBlock: View {
    
    var label: String
    @Binding var checked: Bool
    
    public init(label: String, checked: Binding<Bool>) {
        self.label = label
        self._checked = checked
    }
    
    public var body: some View {
        HStack {
            Image(systemName: checked ? "checkmark.square.fill" : "square")
                .foregroundColor(checked ? Color.accentColor : Color.secondary)
            Text(label)
        }
        .contentShape(RoundedRectangle(cornerRadius: 5))
        .onTapGesture {
            checked.toggle()
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        BooleanBlock(label: "Bool", checked: .constant(true))
    }
}
