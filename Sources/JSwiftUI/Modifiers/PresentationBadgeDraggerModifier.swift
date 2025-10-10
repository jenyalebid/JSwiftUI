//
//  PresentationBadgeDraggerModifier.swift
//  JSwiftUI
//
//  Created by Jenya Lebid on 10/9/25.
//

import SwiftUI

public extension View {
    func badgeDraggingGestures() -> some View {
        modifier(PresentationBadgeDraggerModifier())
    }
}

public struct PresentationBadgeDraggerModifier: ViewModifier {
    
    @State private var dragOffset: CGSize = .zero
    @State private var rotationAngle: Angle = .zero
        
    public func body(content: Content) -> some View {
        content
            .offset(dragOffset)
            .rotationEffect(rotationAngle)
            .rotation3DEffect(
                .degrees(Double(dragOffset.width) * 0.2),
                axis: (x: 0, y: 1, z: 0),
                perspective: 0.8
            )
            .rotation3DEffect(
                .degrees(Double(-dragOffset.height) * 0.2),
                axis: (x: 1, y: 0, z: 0),
                perspective: 0.8
            )
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let resistance: CGFloat = 0.1
                        dragOffset = CGSize(
                            width: value.translation.width * resistance,
                            height: value.translation.height * resistance
                        )
                    }
                    .onEnded { _ in
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                            dragOffset = .zero
                        }
                    }
            )
            .simultaneousGesture(
                RotationGesture()
                    .onChanged { angle in
                        let resistance: Double = 0.3
                        rotationAngle = Angle(degrees: angle.degrees * resistance)
                    }
                    .onEnded { _ in
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                            rotationAngle = .zero
                        }
                    }
            )
    }
}
