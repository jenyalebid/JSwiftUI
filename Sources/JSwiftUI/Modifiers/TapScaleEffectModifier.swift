//
//  SwiftUIView.swift
//  
//
//  Created by Jenya Lebid on 5/18/24.
//

import SwiftUI

struct TapScaleEffectModifier: ViewModifier {
    
    @State private var scale = false
    
    var delay: CGFloat = 0.15
    var scaleChange: CGFloat = 0.9
    
    var allowScale: Bool
    
    var triggerAction: () -> Void
    var delayedAction: () -> Void
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(scale ? scaleChange : 1)
            .onTapGesture {
                withAnimation {
                    if allowScale {
                        scale = true
                    }
                    triggerAction()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    withAnimation {
                        if scale {
                            scale = false
                        }
                        delayedAction()
                    }
                }
            }
    }
}

public extension View {
    
    func tapScaleEffect(allowScale: Bool = true, triggerAction: @escaping () -> Void, delayedAction: @escaping () -> Void) -> some View {
        modifier(TapScaleEffectModifier(allowScale: allowScale, triggerAction: triggerAction, delayedAction: delayedAction))
    }
}

