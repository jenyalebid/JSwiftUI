//
//  LinearGradient.swift
//  JSwiftUI
//
//  Created by Jenya Lebid on 8/15/24.
//

import SwiftUI

public extension LinearGradient {
    
    static func backgroundGradient(for color: Color) -> LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                 color.darker(by: 0.2),
                 color,
                 color.lighter(by: 0.2),
                 color.lighter(by: 0.2)
             ]),
            startPoint: .bottomLeading,
            endPoint: .topTrailing
        )
    }
}
