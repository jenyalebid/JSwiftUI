//
//  GeometryGetter.swift
//  JSwiftUI
//
//  Created by Jenya Lebid on 8/1/25.
//

import SwiftUI

struct GeometryGetter: ViewModifier {
    
    @Binding var size: CGSize?
    var updateOnChange: Bool
    
    func body(content: Content) -> some View {
        content
            .background {
                GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            self.size = geometry.size
                        }
                        .onChange(of: geometry.size) { _, newValue in
                            guard updateOnChange else { return }
                            self.size = newValue
                        }
                }
            }
    }
}

public extension View {
    func geometryGetter(_ size: Binding<CGSize?>, updateOnChange: Bool = true) -> some View {
        modifier(GeometryGetter(size: size, updateOnChange: updateOnChange))
    }
}

