//
//  BooleanPicker.swift
//  JSwiftUI
//
//  Created by Jenya Lebid on 8/1/23.
//

import SwiftUI

public struct BooleanPicker: View {
    
    var leftLabel: String
    var rightLabel: String
    
    @Binding var value: NSNumber
    
    public init(leftLabel: String, rightLabel: String, value: Binding<NSNumber>) {
        self.leftLabel = leftLabel
        self.rightLabel = rightLabel
        self._value = value
    }
    
    public var body: some View {
        HStack {
            BooleanBlock(label: leftLabel, checked: .constant(value == true ? true : false))
                .simultaneousGesture(
                    TapGesture()
                        .onEnded {
                            value = true
                        }
                )
            Divider()
                .frame(height: 20)
                .padding(.horizontal)
            BooleanBlock(label: rightLabel, checked: .constant(value == false ? true : false))
                .simultaneousGesture(
                    TapGesture()
                        .onEnded {
                            value = false
                        }
                )
        }
    }
}

struct BooleanPicker_Previews: PreviewProvider {
    static var previews: some View {
        BooleanPicker(leftLabel: "Left", rightLabel: "Right", value: .constant(0))
    }
}
