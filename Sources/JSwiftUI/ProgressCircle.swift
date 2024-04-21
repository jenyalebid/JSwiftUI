//
//  ProgressCircle.swift
//  JSwiftUI
//
//  Created by Jenya Lebid on 4/21/24.
//

import SwiftUI

public struct ProgressCircle: View {

    var imageName: String?
    var size: CGFloat
    var completionRate: Double
    var ringThickness: CGFloat
    var colorGradient: Gradient
    var backgroundOpacity: Double
    
    var animateOnAppear: Bool = true

    @State private var animationProgress: Double = 0
    @State private var showProgress = false
    
    public init(imageName: String? = nil, size: CGFloat, completionRate: Double, ringThickness: CGFloat, colorGradient: Gradient, backgroundOpacity: Double = 0.2) {
        self.imageName = imageName
        self.size = size
        self.completionRate = completionRate
        self.ringThickness = ringThickness
        self.colorGradient = colorGradient
        self.backgroundOpacity = backgroundOpacity
    }

    private var rotationDegree: Angle {
        .degrees (-90)
    }
    
    private var endAngle: Angle {
        .degrees(animationProgress * 360 - 90)
    }
    
    private var strokeStyle: StrokeStyle {
        StrokeStyle(lineWidth: ringThickness, lineCap: .round)
    }
    
    private var gradientEffect: AngularGradient {
        AngularGradient.init(gradient: colorGradient, center: .center, startAngle: rotationDegree, endAngle: endAngle)
    }
    
    private var gradientEndColor: Color {
        colorGradient.stops.indices.contains(1) ? colorGradient.stops[1].color : Color.clear
    }
    
    private var circleShadow: Color {
        .black.opacity(0.4)
    }
    
    private var overlayPosition: (_ width: CGFloat, _ height: CGFloat) -> CGPoint {
        return { width, height in
            CGPoint(x: width / 2, y: height / 2)
        }
    }
        
    private var overlayOffset: (_ width: CGFloat, _ height: CGFloat) -> CGFloat {
        return { width, height in
            min(width, height) / 2
        }
    }
    
    private var overlayRotation: Angle {
        .degrees(animationProgress * 360 - 90)
    }
    
    private var clippedCircleRotation: Angle {
        .degrees(-90 + animationProgress * 360)
    }
    
    private var shinyGradient: LinearGradient {
        let shinyColors = [Color.white.opacity(0.2), gradientEndColor.opacity(0.2), gradientEndColor]
        return LinearGradient(gradient: Gradient(colors: shinyColors), startPoint: .leading, endPoint: .trailing)
    }
    
    private var fullGradientEffect: AngularGradient {
        AngularGradient(gradient: colorGradient, center: .center, startAngle: .degrees(0), endAngle: .degrees(360))
    }
    
    private var metallicGradient: AngularGradient {
        AngularGradient(
            gradient: Gradient(colors: [
                gradientEndColor.opacity(0), // Transparent
                gradientEndColor.opacity(0.5), // Semi-transparent
                .white, // Bright shine
                gradientEndColor.opacity(0.5),
                gradientEndColor.opacity(0)
            ]),
            center: .center,
            startAngle: .degrees(0),
            endAngle: .degrees(360)
        )
    }

    public var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: ringThickness)
                .foregroundStyle(colorGradient.stops[0].color)
                .opacity(backgroundOpacity)
            Circle()
                .rotation(rotationDegree)
                .trim(from: 0, to: CGFloat(animationProgress))
                .stroke(gradientEffect, style: strokeStyle)
                .shadow(radius: 4)
                .overlay(
                     Circle()
                         .rotation(rotationDegree)
                         .trim(from: 0, to: CGFloat(animationProgress))
                         .stroke(shinyGradient, style: strokeStyle)
                         .blur(radius: 1)
                 )
                .overlay {
                    if animationProgress >= 1.1 {
                        overlayCircle
                    }
                }
                .onAppear {
                    if animateOnAppear {
                        withAnimation(.bouncy(duration: 2)) {
                            animationProgress = completionRate
                        }
                    } else {
                        animationProgress = completionRate
                    }
                }
                .onChange(of: completionRate) { oldValue, newValue in
                    withAnimation {
                        animationProgress = newValue
                    }
                }

        }
        .frame(width: size, height: size)
        .overlay(alignment: .top) {
            if let imageName {
                Image(systemName: imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.black)
                    .frame(height: ringThickness * 0.8)
                    .bold()
                    .offset(y: -((ringThickness * 0.8) * 0.4883))
            }
        }
    }
    
    var overlayCircle: some View {
        GeometryReader { geometry in
            Circle()
                .fill(gradientEndColor)
                .frame(width: ringThickness, height: ringThickness)
                .position(overlayPosition(geometry.size.width, geometry.size.height))
                .offset(x: overlayOffset(geometry.size.width, geometry.size.height))
                .rotationEffect(overlayRotation)
                .shadow(color: circleShadow, radius: ringThickness / 5)
        }
        .clipShape(
            Circle()
                .rotation(clippedCircleRotation)
                .trim(from: 0, to: 0.1)
                .stroke(style: strokeStyle)
        )
    }
}

#Preview {
    ZStack {
        ProgressCircle(size: 200, completionRate: 0.25, ringThickness: 30, colorGradient: Gradient(colors: [.teal, .teal]), backgroundOpacity: 0)
    }
}
