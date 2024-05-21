//
//  ShakeEffectModifier.swift
//  JSwiftUI
//
//  Created by Jenya Lebid on 5/18/24.
//

import SwiftUI

struct ShakeEffectModifier: ViewModifier {
    
    @State private var shake: Bool = false
    
    var offset: CGFloat = 10
    
    var isActive: Bool
    
    func body(content: Content) -> some View {
        content
            .offset(x: shake ? offset : 0)
            .simultaneousGesture(
                TapGesture()
                    .onEnded {
                        guard isActive else { return }
                        shake = true
                        withAnimation(Animation.spring(response: 0.2, dampingFraction: 0.2, blendDuration: 0.2)) {
                            shake = false
                        }
                    }
            )
            .sensoryFeedback(.error, trigger: shake)
    }
}

public extension View {
    func shakeEffect(isActive: Bool = true) -> some View {
        modifier(ShakeEffectModifier(isActive: isActive))
    }
}
