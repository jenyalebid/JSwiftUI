//
//  HexColorPickerBlock.swift
//  JSwiftUI
//
//  Created by Jenya Lebid on 6/30/23.
//

import SwiftUI

public struct HexColorPickerBlock: View {

    @State var color: Color

    var title: String
    @Binding var colorText: String

    public init(title: String, color: Binding<String>) {
        self.title = title
        self._color = State(wrappedValue: Color(hex: color.wrappedValue))
        _colorText = color
    }

    public var body: some View {
        ColorPicker(selection: $color) {
            Text(title)
        }
        .onChange(of: color) { newValue in
            colorText = newValue.hex
        }
        .onChange(of: colorText) { newValue in
            if color.hex != newValue {
                color = Color(hex: newValue)
            }
        }
    }
}

struct HexColorPickerBlock_Previews: PreviewProvider {
    static var previews: some View {
        HexColorPickerBlock(title: "Color", color: .constant("#479FD3"))
    }
}
