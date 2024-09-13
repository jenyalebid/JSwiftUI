//
//  RoundedCorner.swift
//  JSwiftUI
//
//  Created by Jenya Lebid on 9/11/24.
//

import SwiftUI

public struct RoundedCorner: Shape {
    
    public init(radius: CGFloat, _ corners: UIRectCorner = .allCorners) {
        self.radius = radius
        self.corners = corners
    }
    
    var radius: CGFloat = 0
    var corners: UIRectCorner

    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
